import SwiftUI

struct UserView: View {
    let user: User
    var body: some View {
        VStack {
            Text("Profile:")
            WideText(text: "Username: " + user.username)
            WideText(text: "Email: " + user.email)
            WideText(text: "Phone: " + user.phone)
            WideText(text: "Street: " + user.address.street)
            WideText(text: "Suite: " + user.address.suite)
            WideText(text: "City: " + user.address.city)
            WideText(text: "Zipcode: " + user.address.zipcode)
            Spacer()
        }
        .padding()
        .navigationTitle(user.name)
        
    }
}
