import Combine
import Foundation

class NetworkService {
    let baseURL: String
    let urlSession: URLSession

    init(baseURL: String, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
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
