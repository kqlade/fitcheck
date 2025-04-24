import SwiftUI
import AVKit

struct ClosetView: View {
    // MARK: - State
    @State private var selectedCategory: FeedCategory = .theme
    @State private var selectedCategoryText: String = FeedCategory.theme.rawValue
    
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
                Color.white
                    .ignoresSafeArea(.container, edges: [.top, .horizontal])
                
                // 3-column vertical grid of videos with minimal spacing
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
                        ForEach(posts.indices, id: \ .self) { i in
                            VideoPostCell(post: posts[i])
                                .aspectRatio(9/16, contentMode: .fill)
                                .clipped()
                        }
                    }
                    .padding(0)
                }
            }
            .overlay(alignment: .top) {
                CategoryHeaderBar(selected: $selectedCategoryText)
                    .padding(.top, geo.safeAreaInsets.top + 12)
                    .onChange(of: selectedCategoryText) { oldValue, newValue in
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
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview { ClosetView() }
