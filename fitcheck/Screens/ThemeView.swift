import SwiftUI

struct ThemeView: View {
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
                
                // Bracket deck voting UI for Theme tab
                BracketDeckView(posts: posts) {
                    // Called once deck is done – for now just show a toast or reload deck
                }
                // Overlays specific to Theme view (optional: hide if they block bracket)
                // if let current = posts[safe: page] {
                //     SideActionBar(post: current)
                //         .frame(maxWidth: .infinity, alignment: .trailing)
                //         .padding(.trailing, 12)
                //         .padding(.bottom, 120)
                // }
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

#Preview { ThemeView() }
