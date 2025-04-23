import SwiftUI

struct CityView: View {
    // MARK: - Properties
    private let posts: [Post] = [
        .demo  // Using the same demo data structure for now
    ]
    
    @State private var page = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea(.container, edges: [.top, .horizontal])
                
                // City-specific video pager (could filter for city-related content)
                VideoPager(page: $page, posts: posts)
                
                // Overlays specific to City view
                if let current = posts[safe: page] {
                    SideActionBar(post: current)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 12)
                        .padding(.bottom, 120)
                }
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

private extension Collection {
    /// Safe index access: `array[safe: 10]`
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview { CityView() }
