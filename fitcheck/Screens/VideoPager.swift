import SwiftUI

struct VideoPager: View {
    @Binding var page: Int
    let posts: [Post]

    var body: some View {
        GeometryReader { geo in
            if posts.isEmpty {
                Color.black
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                TabView(selection: $page) {
                    ForEach(posts.indices, id: \.self) { i in      // ← fixed stray space
                        VideoPostCell(post: posts[i])
                            // width = container height, height = container width
                            .frame(width: geo.size.height,
                                   height: geo.size.width)
                            .rotationEffect(.degrees(-90))         // rotate cell
                            .tag(i)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .rotationEffect(.degrees(90))                      // rotate pager back
                .frame(width: geo.size.height, height: geo.size.width)
                .scaleEffect(x: -1, y: 1)                         // mirror for natural swipe
            }
        }
        // Respect your global rule: ignore notch + horizontals, but stop at bottom
        .ignoresSafeArea(.container, edges: [.top, .horizontal])
    }
}