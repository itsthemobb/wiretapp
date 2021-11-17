import Foundation
public class WiretappRecordURLProtocol: URLProtocol {
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override func startLoading() {
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if
                let data = data,
                let response = response,
                let self = self
            {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                
                // write to disk here
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    public override func stopLoading() {}
}
