import Foundation

struct Post: Identifiable, Codable, Hashable {
    // MARK: – Identity
    let id: String                    // stable server-side id

    // MARK: – Media
    let url:       URL
    let thumbURL:  URL?
    let duration:  TimeInterval
    let aspect:    CGFloat            // width / height

    // MARK: – Meta
    let user:      String
    let desc:      String
    let trackTitle:  String?          // NEW
    let trackArtist: String?          // NEW

    let likes:     Int64
    let comments:  Int64
    let shares:    Int64
}

/* ───────────── helpers / stubs ───────────── */

extension Post {
    /// Handy example for SwiftUI previews
    static let demo = Post(
        id:       "demo-1",
        url:      URL(fileURLWithPath: "/dev/null"),
        thumbURL: nil,
        duration: 6,
        aspect:   9.0/16.0,
        user:     "@demo",
        desc:     "Sample caption for layout preview.",
        trackTitle:  "original",
        trackArtist: "Mau P",
        likes:    53_500,
        comments: 4_411,
        shares:   1_246
    )

    /// Returns a *copy* with any fields you pass in overridden.
    func with(
        id:          String?      = nil,
        url:         URL?         = nil,
        thumbURL:    URL?         = nil,
        duration:    TimeInterval? = nil,
        aspect:      CGFloat?     = nil,
        user:        String?      = nil,
        desc:        String?      = nil,
        trackTitle:  String??     = nil,
        trackArtist: String??     = nil,
        likes:       Int64?       = nil,
        comments:    Int64?       = nil,
        shares:      Int64?       = nil
    ) -> Post {
        Post(
            id:          id          ?? self.id,
            url:         url         ?? self.url,
            thumbURL:    thumbURL    ?? self.thumbURL,
            duration:    duration    ?? self.duration,
            aspect:      aspect      ?? self.aspect,
            user:        user        ?? self.user,
            desc:        desc        ?? self.desc,
            trackTitle:  trackTitle  ?? self.trackTitle,
            trackArtist: trackArtist ?? self.trackArtist,
            likes:       likes       ?? self.likes,
            comments:    comments    ?? self.comments,
            shares:      shares      ?? self.shares
        )
    }
}
