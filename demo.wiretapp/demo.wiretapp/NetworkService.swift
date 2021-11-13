import Combine
import Foundation

class NetworkService {
    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func get<Response: Decodable>(url: URL, modelType: Response.Type) -> AnyPublisher<Response, Error> {
        URLSession.shared
            .dataTaskPublisher(
                for: URLRequest(url: url)
            )
            .tryMap {
                try JSONDecoder().decode(modelType, from: $0.data)
            }
            .eraseToAnyPublisher()
    }
}
