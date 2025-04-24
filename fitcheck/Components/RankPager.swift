import SwiftUI

struct RankPager: View {
    @Binding var page: Int
    let posts: [Post]

    var body: some View {
        TabView(selection: $page) {
            ForEach(posts.indices, id: \.self) { i in
                VideoPostCell(post: posts[i])
                    .tag(i)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea(.container, edges: [.top, .horizontal])
    }
}

#Preview {
    RankPager(
        page: .constant(0),
        posts: [
            .demo.with(id: "blue", url: URL(string: "blue")!, user: "@blue", desc: "Blue Demo"),
            .demo.with(id: "red", url: URL(string: "red")!, user: "@red", desc: "Red Demo")
        ]
    )
}
