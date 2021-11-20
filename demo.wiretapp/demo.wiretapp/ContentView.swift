import Combine
import Foundation
import SwiftUI

struct Todo: Decodable {
    let title: String
    let completed: Bool
}

struct ContentView: View {
    @State var cancellable: AnyCancellable!
    @State var message: String = "Hello, world!"
    @State var todos: [Todo] = []
    let networkService: NetworkService

    var body: some View {
        VStack {
            ScrollView {
                Text(message)
                    .padding()
                    .onTapGesture {
                        self.cancellable = networkService.get(
                            url: URL(string: "https://jsonplaceholder.typicode.com/todos")!,
                            modelType: [Todo].self
                        )
                        .receive(on: DispatchQueue.main)
                        .sink {
                            print($0)
                        } receiveValue: {
                            todos = $0
                        }
                    }
                LazyVStack {
                    ForEach(todos, id: \.title)  { todo in
                        VStack {
                            Text(todo.title)
                            Text(String(todo.completed))
                        }
                    }
                }
            }
        }
    }
}
