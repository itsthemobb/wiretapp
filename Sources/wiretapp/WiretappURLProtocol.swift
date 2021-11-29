import Foundation

private var urlCounter: [String: Int] = [:]

public class WiretappURLProtocol: URLProtocol {
    typealias Output = (data: Data, response: URLResponse)
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override class func canInit(with request: URLRequest) -> Bool {
        ProcessInfo.processInfo.environment[Wiretapp.testCaseName] != nil
    }

    public override func startLoading() {
        let processedInfo = send(request)
        switch processedInfo {
        case .success(let output):
            client?.urlProtocol(self, didReceive: output.response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: output.data)

        case .failure(let error):
            fatalError(error.localizedDescription)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    public override func stopLoading() {}
}

// MARK: - Private
private extension WiretappURLProtocol {
    func send(_ request: URLRequest) -> Result<Output, Error> {
        guard let url = request.url else {
            return .failure(WiretappSessionError.noURL)
        }

        do {
            // try by incrementing
            urlCounter[url.path, default: -1] += 1
            if let mockData = try loadJsonFromTestFolder(file: url.path) {
                return process(mockData: mockData, url: url)
            }

            // second try, reset to 0
            urlCounter[url.path, default: -1] = 0
            if let mockData = try loadJsonFromTestFolder(file: url.path) {
                return process(mockData: mockData, url: url)
            }

            // try default folder
            if let mockData = try loadJsonFromDefaultFolder(file: url.path) {
                return process(mockData: mockData, url: url)
            }
        } catch {
            return .failure(error)
        }

        return .failure(
            WiretappSessionError.unableToLocateResponse(
                url.path.replacingOccurrences(of: "/", with: ":") +
                "\(String(describing: urlCounter[url.path]))" +
                ".json"
            )
        )
    }

    func loadJsonFromTestFolder(file: String) throws -> Data? {
        guard let testName = ProcessInfo.processInfo.environment[Wiretapp.testCaseName] else {
            throw WiretappError.unableToLocateTestCasePath
        }
        if let count = urlCounter[file] {
            let fullPath = "file://" +
                            testName + "/" +
                            file.replacingOccurrences(of: "/", with: ":") +
                            "/\(String(describing: count))" +
                            ".json"
            do {
                if let url = URL(string: fullPath) {
                    return try Data(contentsOf: url)
                }
            } catch {
                throw error
            }
        }
        return nil
    }

    func loadJsonFromDefaultFolder(file: String) throws -> Data? {
        let filename = file.replacingOccurrences(of: "/", with: ":")
        guard let defaultPath = ProcessInfo.processInfo.environment[Wiretapp.responsePath] else {
            throw WiretappError.unableToLocateResponses
        }
        if let url = URL(string: defaultPath + "default/" + filename + ".json") {
            return try? Data(contentsOf: url)
        }
        return nil
    }

    func process(mockData: Data, url: URL) -> Result<Output, Error>  {
        do {
            if
                let body = try JSONSerialization.jsonObject(with: mockData) as? [String: Any],
                let statusCode = body["status"] as? Int,
                let responseJSON = body["response"],
                JSONSerialization.isValidJSONObject(responseJSON),
                let urlResponse = HTTPURLResponse(
                    url: url,
                    statusCode: statusCode,
                    httpVersion: "1.1",
                    headerFields: nil
                ) {
                let data = try JSONSerialization.data(withJSONObject: responseJSON, options: .prettyPrinted)
                return .success((data: data, response: urlResponse))
            }
            return .failure(WiretappSessionError.unableToParseResponse)
        } catch {
            return .failure(error)
        }
    }
}
