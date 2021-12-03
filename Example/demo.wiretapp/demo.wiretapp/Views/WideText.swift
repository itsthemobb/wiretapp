import SwiftUI
struct WideText: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
    }
}
