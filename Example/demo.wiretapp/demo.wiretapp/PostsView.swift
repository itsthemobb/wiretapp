import Combine
import SwiftUI

struct PostsView: View {
    @State var cancellable: AnyCancellable!
    @State var todos: [Todo] = []
    let networkService: NetworkService
    let users: [User]

    var body: some View {
        VStack {
            fetchButton()
            ScrollView {
                LazyVStack {
                    ForEach(todos, id: \.title)  { todo in
                        return todoCell(todo)
                    }
                }
            }
        }
    }
}

extension PostsView {
    fileprivate func todoCell(_ todo: Todo) -> some View {
        VStack {
            HStack {
                Image(systemName:
                        todo.completed
                      ? "checkmark.circle.fill"
                      : "x.circle.fill"
                )
                Text(todo.title)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }
            Divider()
        }
        .padding(4)
    }
    
    fileprivate func fetchButton() -> some View {
        Text("Fetch To-Do's")
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
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
    }
}
