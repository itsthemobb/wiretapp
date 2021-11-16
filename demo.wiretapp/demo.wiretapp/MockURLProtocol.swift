import Foundation

public class MockURLProtocol: URLProtocol {
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override func startLoading() {
        loadMock()
    }

    public override func stopLoading() {}
}

// MARK: - Private
private extension MockURLProtocol {
    class func url(for request: URLRequest) -> URL? {
        let count = 0
        guard
            let directory = ProcessInfo.processInfo.environment[Wiretapp.testCasePath],
            let fileName = request.url?.path.replacingOccurrences(of: "/", with: ":"),
            let url = URL(string: directory + "/" + fileName + "/" + "\(String(describing: count))" + ".json") else {
                return nil
        }
        return url
    }
    
    func loadMock() {
        guard
            let fileURL = MockURLProtocol.url(for: request),
            let url = request.url,
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil),
            let client = self.client
        else { return }

        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        if let data = try? Data(contentsOf: fileURL) {
            client.urlProtocol(self, didLoad: data)
        }

        client.urlProtocolDidFinishLoading(self)
    }
    
//
//    open func loadJsonFromTestFolder(file: String) -> Data? {
//        let filename = file.replacingOccurrences(of: "/", with: ":")
//        if
//            let count = urlCounter[file],
//            let url = URL(string: directory + "/" + filename + "/" + "\(String(describing: count))" + ".json")
//        {
//            return try? Data(contentsOf: url)
//        }
//        return nil
//    }
//
//    open func loadJsonFromDefaultFolder(file: String) -> Data? {
//        let filename = file.replacingOccurrences(of: "/", with: ":")
//        if
//            let defaultPath = ProcessInfo.processInfo.environment["mock_responses"],
//            let url = URL(string: defaultPath + "default/" + filename + ".json")
//        {
//            return try? Data(contentsOf: url)
//        }
//        return nil
//    }
}
