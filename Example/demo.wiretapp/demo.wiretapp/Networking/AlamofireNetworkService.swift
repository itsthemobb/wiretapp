import Alamofire
import Combine
import Foundation

class AlamofireNetworkService: NetworkServiceType {
    let session: Session

    init(configuration: URLSessionConfiguration) {
        session = Session(configuration: configuration)
    }

    func get<Response: Decodable>(url: URL, modelType: Response.Type) -> AnyPublisher<Response, Error> {
        Future { promise in
            self.session.request(url)
                .responseDecodable(of: Response.self) { response in
                promise(response.result.mapError { $0 as Error })
            }
        }
        .eraseToAnyPublisher()
    }
}
