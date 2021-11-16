import SwiftUI

@main
struct demo_wiretappApp: App {
    var body: some Scene {
        setup()
        return WindowGroup {
            ContentView(networkService: NetworkService(baseURL: "https://google.com"))
        }
    }

    func setup() {
        Wiretapp.configure()
    }
}
