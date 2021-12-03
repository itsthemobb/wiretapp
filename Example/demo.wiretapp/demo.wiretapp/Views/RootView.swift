import Combine
import Foundation
import SwiftUI

struct RootView: View {
    @State var cancellable: AnyCancellable!
    let networkService: NetworkService

    var body: some View {
        TabView {
            NavigationView {
                PostsView(networkService: networkService)
            }
            .tabItem {
                Label("Posts", systemImage: "list.bullet.circle")
            }
            
            NavigationView {
                UsersView(networkService: networkService)
            }
            .tabItem {
                Label("Users", systemImage: "person.3.fill")
            }
        }
    }
}
