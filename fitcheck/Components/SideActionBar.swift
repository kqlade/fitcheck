import SwiftUI

enum ClipSide { case left, right }     // tiny helper enum

struct SideActionBar: View {
    private enum C {
        static let icon:    CGFloat = 28
        static let spacing: CGFloat = 22
        static let edgeInset: CGFloat = 16
    }

    let post:  Post
    let side:  ClipSide                // ← new

    var body: some View {
        VStack(spacing: C.spacing) {
            saveButton
            shareButton
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .padding(edgeInset)            // hug chosen edge
    }

    // MARK: – Buttons
    private var saveButton: some View {
        Button { toggleSave(post) } label: {
            Image(systemName: "bookmark.fill")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: C.icon, height: C.icon)
                .foregroundColor(.white)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(post.isSaved ? "Saved" : "Save")
    }

    private var shareButton: some View {
        Button { share(post) } label: {
            Image(systemName: "arrowshape.turn.up.right.fill")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: C.icon, height: C.icon)
                .foregroundColor(.white)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Share")
    }

    // MARK: – Helpers
    private func toggleSave(_ post: Post) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        // BookmarkManager.shared.toggle(post)
    }

    private func share(_ post: Post) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let url = URL(string: "https://fitcheck.app/theme/\(post.id)")!
        let avc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        scene.windows.first?.rootViewController?.present(avc, animated: true)
    }

    // Edge-specific padding helper
    private var edgeInset: EdgeInsets {
        switch side {
        case .left:
            return EdgeInsets(top: 0, leading: C.edgeInset, bottom: 0, trailing: 0)
        case .right:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: C.edgeInset)
        }
    }
}

/* ---------- preview ---------- */
#Preview {
    GeometryReader { geo in
        ZStack {
            Color.blue
            SideActionBar(post: Post.demo, side: .left)
        }
        .frame(width: geo.size.width / 2)   // mimic half-screen
    }
}
