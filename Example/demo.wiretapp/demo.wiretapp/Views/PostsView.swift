import Combine
import SwiftUI

struct PostsView: View {
    @State var cancellable: AnyCancellable!
    @State var posts: [Post] = []
    @State var users: [User] = []
    let networkService: NetworkService

    var body: some View {
        VStack {
            ScrollView {
                ForEach(posts, id: \.title)  { post in
                    return postCell(post, user: users.first(where: { $0.id == post.userId }))
                }
            }
        }
        .navigationTitle("Posts")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    getPosts()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                }
            }
        }
        .onAppear {
            getPosts()
        }
    }
}

extension PostsView {
    fileprivate func postCell(_ post: Post, user: User?) -> some View {
        VStack {
            WideText(text: "Title: \n" + post.title)
                .padding([.bottom], 5)
            WideText(text: "Body: \n" + post.body)
                .padding([.bottom], 5)
            user.map {
                WideText(text: "Author: \n\($0.name)")
            }
            Divider()
        }
        .padding()
    }
    
    func getPosts() {
        posts = []
        self.cancellable = Publishers.CombineLatest(
            networkService.get(
                url: URL(string: "https://jsonplaceholder.typicode.com/users")!,
                modelType: [User].self
            ).eraseToAnyPublisher(),
            networkService.get(
                url: URL(string: "https://jsonplaceholder.typicode.com/posts")!,
                modelType: [Post].self
            ).eraseToAnyPublisher()
        )
        .receive(on: DispatchQueue.main)
        .sink {
            print($0)
        } receiveValue: {
            users = $0
            posts = $1
        }
    }
}
