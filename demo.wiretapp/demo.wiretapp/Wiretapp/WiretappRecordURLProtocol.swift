import Foundation
public class WiretappRecordURLProtocol: URLProtocol {
    typealias Output = (data: Data, response: URLResponse)
    var urlCounter: [String: Int] = [:]
    let recordPath: String = ""
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override func startLoading() {
        self.
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if
                let data = data,
                let response = response,
                let self = self
            {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
                // write to disk here
                
                if
                    let responsePath = ProcessInfo.processInfo.environment["mock_responses"],
                    let directory = URL(string: responsePath),
                    let response = response as? HTTPURLResponse,
                    let filename = self.request.url?.path.fileName,
                    let docURL = URL(string: responsePath)
                {
                    self.urlCounter[filename, default: -1] += 1
                    var timesRecorded = 0

                    if let urlCount = self.urlCounter[filename] {
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
                        // create record path folder and api path folders
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
    }
    func createFolder(url: URL) throws {
        if !FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.createDirectory(
                atPath: url.path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
    public override func stopLoading() {}
}


private extension String {
    var fileName: String {
        replacingOccurrences(of: "/", with: ":")
    }
}
