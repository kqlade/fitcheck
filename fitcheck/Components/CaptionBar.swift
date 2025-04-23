import SwiftUI

struct CaptionBar: View {
    let post: Post
    
    // stub track until the model carries one
    private var trackTitle: String { post.trackTitle ?? "original" }
    private var trackArtist: String { post.trackArtist ?? "Mau P" }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            // ── User handle ───────────────────────────────────────────
            Text(post.user)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
            
            // ── Caption (max 2 lines) ────────────────────────────────
            Text(post.desc)
                .font(.system(size: 14))
                .lineLimit(2)
                .truncationMode(.tail)
                .foregroundStyle(.white)
            
            // ── Music row ────────────────────────────────────────────
            HStack(spacing: 4) {
                Image(systemName: "music.note")
                Text("\(trackTitle) • \(trackArtist)")
            }
            .font(.system(size: 13))
            .foregroundStyle(.secondary)      // keeps the dim tone
            .accessibilityElement(children: .combine)
        }
        .padding([.vertical, .trailing], 4)   // tiny breathing room
        .shadow(radius: 4)
        // Subtle top fade so caption blends into video
        .background(
            LinearGradient(colors: [.black.opacity(0.6), .clear],
                           startPoint: .top, endPoint: .bottom)
                .allowsHitTesting(false)
        )
        // Single VoiceOver label
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CaptionBar(
            post: Post.demo.with(
                desc: "Mau P @ MAU YUMA  LADIES AND GENTLEMAN MAU P IS DANCIN!…"
            )
        )
    }
}