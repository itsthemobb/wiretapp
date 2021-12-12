import Combine
import Foundation
import SwiftUI

struct RootView: View {
    @State var network: NetworkType = .urlSession

    var body: some View {
        TabView {
            NavigationView {
                PostsView(networkService: network.service)
            }
            .tabItem {
                Label("Posts", systemImage: "doc.plaintext")
            }

            NavigationView {
                UsersView(networkService: network.service)
            }
            .tabItem {
                Label("Users", systemImage: "person.3")
            }

            NavigationView {
                SettingsView(selection: $network)
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}
