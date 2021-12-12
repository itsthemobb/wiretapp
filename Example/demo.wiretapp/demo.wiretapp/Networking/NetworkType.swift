import Alamofire
import Foundation
import Wiretapp

enum NetworkType: String, CaseIterable {
    case urlSession = "URL Session"
    case alamofire = "Alamofire"

    var service: NetworkServiceType {
        switch self {
        case .urlSession:
            Wiretapp.registerSharedSession()
            return URLSessionNetworkService(urlSession: URLSession.shared)

        case .alamofire:
            var config = URLSessionConfiguration.default
            config = Wiretapp.register(configuration: config)
            return AlamofireNetworkService(configuration: config)
        }
    }
}
