import SwiftUI
import AVKit

struct FeedView: View {
    // MARK: – Demo content
    private let posts: [Post] = [
        .demo       // helper from Post.extension we added earlier
    ]
    
    @State private var page        = 0
    @State private var selectedTab = "For You"
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ① Black fallback (video usually covers everything)
                Color.black
                    .ignoresSafeArea(.container, edges: [.top, .horizontal])
                
                // ② Vertical-swipe pager
                VideoPager(page: $page, posts: posts)
                
                // ③ Overlays (no header here)
                if let current = posts[safe: page] {
                    SideActionBar(post: current)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 12)
                        .padding(.bottom, 120)
                    

                }
            }
            .overlay(alignment: .top) {
                CategoryHeaderBar(selected: $selectedTab)
                    .padding(.top, geo.safeAreaInsets.top + 12)
            }
            .overlay(alignment: .bottomLeading) {
                if let current = posts[safe: page] {
                    CaptionBar(post: current)
                        .padding(.leading, 16)
                        .padding(.bottom, 72)
                }
            }
            .ignoresSafeArea(.container, edges: [.top, .horizontal])
        }
    }
}

/* ───────────── helpers ───────────── */

private extension Collection {
    /// Safe index access: `array[safe: 10]`
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview { FeedView() }