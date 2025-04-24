import SwiftUI
import AVKit

struct RankingView: View {
    // MARK: - State
    @State private var selectedCategory: FeedCategory = .theme
    @State private var selectedCategoryText: String = FeedCategory.theme.rawValue
    @State private var currentPage: Int = 0
    
    // MARK: - Properties
    private let posts: [Post] = [
        .demo.with(id: "blue", url: URL(string: "blue")!, user: "@blue", desc: "Blue Demo"),
        .demo.with(id: "red", url: URL(string: "red")!, user: "@red", desc: "Red Demo"),
        .demo.with(id: "blue2", url: URL(string: "blue")!, user: "@blue", desc: "Blue Demo 2"),
        .demo.with(id: "red2", url: URL(string: "red")!, user: "@red", desc: "Red Demo 2")
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea(.container, edges: [.top, .horizontal])
                
                // TikTok-style full-screen video pager (standard vertical scrolling)
                ZStack(alignment: .trailing) {
                    RankPager(page: $currentPage, posts: posts)
                    
                    // Action buttons with counters on the right side
                    if let currentPost = posts[safe: currentPage] {
                        RankActionBar(post: currentPost)
                    }
                }

            }
            // .overlay(alignment: .bottomLeading) {
            //     if let current = posts[safe: page] {
            //         CaptionBar(post: current)
            //             .padding(.leading, 16)
            //             .padding(.bottom, 72)
            //     }
            // }
            .overlay(alignment: .top) {
                // Category header bar that stays consistent across all views
                CategoryHeaderBar(selected: $selectedCategoryText)
                    .padding(.top, geo.safeAreaInsets.top + 12)
                    .onChange(of: selectedCategoryText) { oldValue, newValue in
                        // Update the enum value when text changes
                        if let newCategory = FeedCategory.allCases.first(where: { $0.rawValue == newValue }) {
                            selectedCategory = newCategory
                        }
                    }
            }
            .ignoresSafeArea(.container, edges: [.top, .horizontal])
        }
    }
}

private extension Collection {
    /// Safe index access: `array[safe: 10]`
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview { RankingView() }
