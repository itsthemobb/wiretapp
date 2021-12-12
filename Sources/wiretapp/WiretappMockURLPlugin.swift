import Foundation

private var urlCounter: [String: Int] = [:]
internal class WiretappMockURLPlugin: URLProtocol {
    typealias Output = (data: Data, response: URLResponse)
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override class func canInit(with request: URLRequest) -> Bool {
        guard let testCaseName = ProcessInfo.processInfo.environment[Wiretapp.testCaseName] else {
            return false
        }
        return !testCaseName.isEmpty
    }

    override func startLoading() {
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

    override func stopLoading() {}
}

// MARK: - Private
private extension WiretappMockURLPlugin {
    func send(_ request: URLRequest) -> Result<Output, Error> {
        guard let url = request.url else {
            return .failure(WiretappError.noURL)
        }

        // try by incrementing
        urlCounter[url.path, default: -1] += 1
        if let mockData = loadJsonFromTestFolder(file: url.path) {
            return process(mockData: mockData, url: url)
        }

        // second try, reset to 0
        urlCounter[url.path, default: -1] = 0
        if let mockData = loadJsonFromTestFolder(file: url.path) {
            return process(mockData: mockData, url: url)
        }

        // try default folder
        if let mockData = loadJsonFromDefaultFolder(file: url.path) {
            return process(mockData: mockData, url: url)
        }

        return .failure(
            WiretappError.unableToLocateResponse(
                url.path.replacingOccurrences(of: "/", with: ":") +
                "\(String(describing: urlCounter[url.path]))" +
                ".json"
            )
        )
    }

    func loadJsonFromTestFolder(file: String) -> Data? {
        if
            let testName = ProcessInfo.processInfo.environment[Wiretapp.testCaseName],
            let count = urlCounter[file]
        {
            let fullPath = "file://" +
                            testName + "/" +
                            file.replacingOccurrences(of: "/", with: ":") +
                            "/\(String(describing: count))" +
                            ".json"
            if let url = URL(string: fullPath) {
                return try? Data(contentsOf: url)
            }
        }
        return nil
    }

    func loadJsonFromDefaultFolder(file: String) -> Data? {
        let filename = file.replacingOccurrences(of: "/", with: ":")
        if
            let defaultPath = ProcessInfo.processInfo.environment[Wiretapp.responsePath],
            let url = URL(string: "file://" + defaultPath + "default/" + filename + ".json")
        {
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
            return .failure(WiretappError.unableToParseResponse)
        } catch {
            return .failure(error)
        }
    }
}
