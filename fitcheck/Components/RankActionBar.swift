import SwiftUI
import UIKit

struct RankActionBar: View {
    let post: Post
    
    // Sample metrics for UI mock-up (fixed per instance)
    private let likes    = Int.random(in: 10_000...99_999)
    private let comments = Int.random(in:   100...999)
    private let shares   = Int.random(in: 1_000...9_999)
    private let saves    = Int.random(in:   100...9_999)
    
    // Layout constants
    private enum Layout {
        static let buttonSize: CGFloat = 30
        static let spacing: CGFloat    = 16
        static let edgeInset: CGFloat  = 16
    }
    
    var body: some View {
        VStack(spacing: Layout.spacing) {
            // Like
            ActionButton(
                icon: "heart.fill",
                count: formatNumber(likes),
                size: Layout.buttonSize,
                action: { /* Like action */ }
            )
            // Comment
            ActionButton(
                icon: "ellipsis.bubble.fill",
                count: formatNumber(comments),
                size: Layout.buttonSize,
                action: { /* Comment action */ }
            )
            // Share
            ActionButton(
                icon: "arrowshape.turn.up.right.fill",
                count: formatNumber(shares),
                size: Layout.buttonSize,
                action: { share(post) }
            )
            // Save
            ActionButton(
                icon: "bookmark.fill",
                count: formatNumber(saves),
                size: Layout.buttonSize,
                action: { toggleSave(post) }
            )
        }
        .padding(.trailing, Layout.edgeInset)
        .padding(.bottom, 20)
    }
    
    // Format numbers TikTok-style (e.g., 53.5K)
    private func formatNumber(_ value: Int) -> String {
        switch value {
        case 1_000_000...:
            return String(format: "%.1fM", Double(value) / 1_000_000)
        case 1_000...:
            return String(format: "%.1fK", Double(value) / 1_000)
        default:
            return "\(value)"
        }
    }
    
    // MARK: – Actions
    private func toggleSave(_ post: Post) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        // BookmarkManager.shared.toggle(post)
    }
    
    private func share(_ post: Post) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root  = scene.windows.first?.rootViewController else { return }
        
        let url = URL(string: "https://fitcheck.app/theme/\(post.id)")!
        let avc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        root.present(avc, animated: true)
    }
}

// MARK: – Single action button
private struct ActionButton: View {
    let icon: String
    let count: String
    let size: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                Text(count)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(.white)
        }
    }
}

// MARK: – Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RankActionBar(post: .demo)   // assumes Post.demo exists
    }
}
