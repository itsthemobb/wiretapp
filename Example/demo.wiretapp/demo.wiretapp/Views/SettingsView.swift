import Foundation
import SwiftUI

struct SettingsView: View {
    @Binding private var selection: NetworkType

    init(selection: Binding<NetworkType>) {
        self._selection = selection
    }

    var body: some View {
        List {
            Section(header: Text("Select the network implementation to use: ")) {
                ForEach(NetworkType.allCases, id: \.self) { name in
                    Button(action: { selection = name }, label: {
                        HStack {
                            Text(name.rawValue)
                            Spacer()
                            if name == selection {
                                Image(systemName: "checkmark")
                            }
                        }
                    })
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Settings")
    }
}
