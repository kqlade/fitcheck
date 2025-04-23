import SwiftUI

struct SideActionBar: View {
    private enum C {               // constants
        static let avatar:  CGFloat = 42
        static let icon:    CGFloat = 28
        static let spacing: CGFloat = 22
    }

    let post: Post
    @State private var isFollowing = false

    var body: some View {
        VStack(spacing: C.spacing) {

            Circle()
                .fill(Color.white)
                .frame(width: C.avatar, height: C.avatar)
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .padding(.bottom, 8)

            Button {
                isFollowing.toggle()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: isFollowing ? "checkmark" : "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.pink)
                    .padding(10)
                    .background(Circle().fill(Color.white))
            }
            .offset(y: -20)
            .accessibilityLabel(isFollowing ? "Following" : "Follow")

            actionButton("heart.fill",             post.likes,    label: "Like")
            actionButton("bubble.right.fill",      post.comments, label: "Comment")
            actionButton("arrowshape.turn.up.right.fill", post.shares, label: "Share")

            Button { /* bookmark */ } label: {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: C.icon))
            }
            .buttonStyle(.plain)
            .foregroundColor(.white)
            .accessibilityLabel("Save")
        }
        .padding(.trailing, 8)
    }

    // MARK: – Helpers
    @ViewBuilder
    private func actionButton(_ sf: String, _ count: Int64, label: String) -> some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            VStack(spacing: 4) {
                Image(systemName: sf)
                    .font(.system(size: C.icon))
                Text(format(count))
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(.white)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }

    private func format(_ n: Int64) -> String {
        switch n {
        case 1_000_000...: return String(format: "%.1fM", Double(n) / 1_000_000)
        case 10_000...:    return String(format: "%.1fK", Double(n) / 1_000)
        default:           return "\(n)"
        }
    }
}

#Preview {
    ZStack { Color.black.ignoresSafeArea()
        SideActionBar(
            post: Post.demo.with(
                likes: 135_000,
                comments: 4_411,
                shares: 1_246
            )
        )
    }
}
