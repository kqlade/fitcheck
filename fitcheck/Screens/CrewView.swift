import SwiftUI
import AVKit

/// Shows the feed scoped to friends/crew only.
struct CrewView: View {
    // MARK: - Properties
    private let posts: [Post] = [
        .demo.with(id: "blue", url: URL(string: "blue")!, user: "@blue", desc: "Blue Demo (Crew)"),
        .demo.with(id: "red", url: URL(string: "red")!, user: "@red", desc: "Red Demo (Crew)"),
        .demo.with(id: "blue2", url: URL(string: "blue")!, user: "@blue", desc: "Blue Demo 2 (Crew)"),
        .demo.with(id: "red2", url: URL(string: "red")!, user: "@red", desc: "Red Demo 2 (Crew)")
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea(.container, edges: [.top, .horizontal])
                
                // Bracket deck voting UI for Crew tab
                BracketDeckView(posts: posts) {
                    // Called once deck is done – for now just show a toast or reload deck
                }
            }
            // .overlay(alignment: .bottomLeading) {
            //     if let current = posts[safe: page] {
            //         CaptionBar(post: current)
            //             .padding(.leading, 16)
            //             .padding(.bottom, 72)
            //     }
            // }
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

#Preview { CrewView() }
