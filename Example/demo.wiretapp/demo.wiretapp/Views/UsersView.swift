import Combine
import SwiftUI

struct UsersView: View {
    @State var cancellable: AnyCancellable!
    @State var users: [User] = []
    let networkService: NetworkService

    var body: some View {
        ScrollView {
            ForEach(users, id: \.name) { user in
                NavigationLink(destination: UserView(user: user)) {
                    VStack {
                        WideText(text: "Name: " + user.name)
                        WideText(text: "Username: " + user.username)
                        WideText(text: "E-mail: " + user.email)
                    }
                    Divider()
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
        }
        .navigationTitle("Users")
        .onAppear {
            getUsers()
        }
    }
    
    func getUsers() {
        users = []
        self.cancellable = networkService.get(
            url: URL(string: "https://jsonplaceholder.typicode.com/users")!,
            modelType: [User].self
        )
        .receive(on: DispatchQueue.main)
        .sink {
            print($0)
        } receiveValue: {
            users = $0
        }
    }
}
