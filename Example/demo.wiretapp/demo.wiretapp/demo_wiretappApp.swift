import SwiftUI
import Wiretapp

@main
struct demo_wiretappApp: App {
    let urlSession: URLSession!

    init() {
        var config = URLSessionConfiguration.default
        config = Wiretapp.register(configuration: config)
        self.urlSession = URLSession(configuration: config)
    }

    var body: some Scene {
        return WindowGroup {
            RootView(
                networkService: NetworkService(
                    baseURL: "https://google.com",
                    urlSession: urlSession
                )
            )
        }
    }
}
