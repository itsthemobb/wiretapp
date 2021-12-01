import Combine
import SwiftUI

struct PostsView: View {
    @State var cancellable: AnyCancellable!
    @State var posts: [Post] = []
    let networkService: NetworkService
    let users: [User]

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(posts, id: \.title)  { post in
                        return postCell(post, user: users.first(where: { $0.id == post.userId }))
                    }
                }
            }
        }
        .onAppear {
            getPosts()
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
    }
}

extension PostsView {
    fileprivate func postCell(_ post: Post, user: User?) -> some View {
        VStack {
            Text("Title: \n" + post.title)
                .font(.caption)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding([.bottom], 5)
            Text("Body: \n" + post.body)
                .font(.caption)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding([.bottom], 5)
            user.map {
                Text("Author: \($0.name)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }
            Divider()
        }
        .padding()
    }
    
    func getPosts() {
        posts = []
        self.cancellable = networkService.get(
            url: URL(string: "https://jsonplaceholder.typicode.com/posts")!,
            modelType: [Post].self
        )
        .receive(on: DispatchQueue.main)
        .sink {
            print($0)
        } receiveValue: {
            posts = $0
        }
    }
}
