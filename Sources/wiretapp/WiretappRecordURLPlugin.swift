import Foundation

private var urlCounter: [String: Int] = [:]
internal class WiretappRecordURLPlugin: URLProtocol {
    typealias Output = (data: Data, response: URLResponse)
    let recordPath: String = "recorded/"
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override class func canInit(with request: URLRequest) -> Bool {
        if let
            recordingEnabled = ProcessInfo.processInfo.environment[Wiretapp.recordEnabled],
            recordingEnabled == "true"
        {
            return true
        }
        return false
    }

    override func startLoading() {
        send()
    }

    override func stopLoading() {}
}

extension WiretappRecordURLPlugin {
    func createFolder(url: URL) throws {
        if !FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.createDirectory(
                atPath: url.path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }

    func send() {
        URLSession(configuration: .ephemeral).dataTask(with: request) { [weak self] data, response, error in
            if
                let data = data,
                let response = response,
                let self = self
            {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)

                if
                    let responsePath = ProcessInfo.processInfo.environment[Wiretapp.responsePath],
                    let directory = URL(string: "file://" + responsePath),
                    let response = response as? HTTPURLResponse,
                    let filename = self.request.url?.path.replacingOccurrences(of: "/", with: ":"),
                    let docURL = URL(string: responsePath)
                {
                    urlCounter[filename, default: -1] += 1
                    var timesRecorded = 0

                    if let urlCount = urlCounter[filename] {
                        timesRecorded = urlCount
                    }

                    let pathWithFileName = directory
                        .appendingPathComponent(self.recordPath)
                        .appendingPathComponent(filename.appending("/\(timesRecorded).json"))

                    do {
                        let body = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        let dictionary: [String: Any] = [
                            "status": response.statusCode,
                            "response": body ?? [:]
                        ]
                        try self.createFolder(url: docURL.appendingPathComponent(self.recordPath))
                        try self.createFolder(url: docURL.appendingPathComponent(self.recordPath).appendingPathComponent(filename))

                        try JSONSerialization
                            .data(withJSONObject: dictionary, options: .prettyPrinted)
                            .write(to: pathWithFileName)

                        print("RECORDED TO PATH: ", pathWithFileName, "\n\n\n")
                    } catch {
                        print("ERROR RECORDING: ", error, "\n\n\n")
                    }
                }
            }
        }
        .resume()
    }
}
