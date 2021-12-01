import SwiftUI

struct UsersView: View {
    let users: [User]
    var body: some View {
        ScrollView {
            ForEach(users, id: \.name) { user in
                VStack {
                    Text("Name: " + user.name)
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                    Text("Username: " + user.username)
                        .font(.caption)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                    Text("E-mail: " + user.email)
                        .font(.caption)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                Divider()
            }
            .padding()
        }
        .navigationTitle("Users")
    }
}
