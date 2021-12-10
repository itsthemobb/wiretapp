import Combine
import Foundation

protocol NetworkServiceType {
    func get<Response: Decodable>(url: URL, modelType: Response.Type) -> AnyPublisher<Response, Error>
}

class URLSessionNetworkService: NetworkServiceType {
    let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func get<Response: Decodable>(url: URL, modelType: Response.Type) -> AnyPublisher<Response, Error> {
        urlSession
            .dataTaskPublisher(
                for: URLRequest(url: url)
            )
            .tryMap {
                try JSONDecoder().decode(modelType, from: $0.data)
            }
            .eraseToAnyPublisher()
    }
}
