import SwiftUI

// MARK: – Top-level deck
struct BracketDeckView: View {
    let onComplete: () -> Void
    
    @State private var queue : [BattlePost]
    @State private var finals: [BattlePost] = []
    @State private var current: (BattlePost, BattlePost)?
    @State private var pairsVoted = 0
    
    // retire after this many consecutive wins
    private let winCap = 3
    
    init(posts: [Post], onComplete: @escaping () -> Void = {}) {
        self.onComplete = onComplete
        _queue = State(initialValue: posts.shuffled().map {
            BattlePost(id: $0.id, post: $0)
        })
    }
    
    var body: some View {
        GeometryReader { geo in
            if let duel = current {
                TapPairView(left: duel.0.post,
                            right: duel.1.post,
                            width: geo.size.width / 2) { side in
                    vote(side, duel: duel)
                }
            } else {
                // Deck finished: trigger completion and show nothing
                Color.clear.onAppear(perform: onComplete)
            }
        }
        .onAppear(perform: nextPair)
    }
    
    // MARK: – Voting logic
    private func vote(_ side: VoteSide, duel: (BattlePost, BattlePost)) {
        pairsVoted += 1
        
        var winner   = (side == .left ? duel.0 : duel.1)
        winner.wins += 1 // consecutive win
        
        // Remove the loser; it never returns this session
        // (If you want consolation bracket, push to another array here)
        
        // Champion retires after 3 wins
        if winner.wins >= winCap {
            finals.append(winner)
            nextPair() // two brand-new contenders
            return
        }
        
        // Pull next challenger
        guard let challenger = queue.first else {
            current = nil // deck exhausted
            return
        }
        queue.removeFirst() // pop off queue
        
        // IMPORTANT: keep winner on same side
        current = side == .left
            ? (winner, challenger) // winner left, challenger right
            : (challenger, winner) // challenger left, winner right
    }
    
    private func nextPair() {
        guard queue.count >= 2 else {
            current = nil
            return
        }
        current = (queue.removeFirst(), queue.removeFirst())
    }
    
}

// MARK: – Pair view (double-tap pick, loser slides out)
enum VoteSide { case left, right }

private struct TapPairView: View {
    let left, right: Post
    let width: CGFloat
    let onVote: (VoteSide) -> Void
    
    @State private var offsets: [VoteSide: CGFloat] = [.left: 0, .right: 0]
    
    var body: some View {
        HStack(spacing: 0) {
            tappableHalf(post: left,  side: .left)
            tappableHalf(post: right, side: .right)
        }
        .ignoresSafeArea(.container, edges: [.top, .horizontal])
    }
    
    @ViewBuilder
    private func tappableHalf(post: Post, side: VoteSide) -> some View {
        VideoPostCell(post: post)
            .frame(width: width)
            .offset(x: offsets[side, default: 0])
            .rotation3DEffect(
                .degrees(rotations[side, default: 0]),
                axis: (x: 0, y: 0, z: 1),
                anchor: side == .left ? .trailing : .leading
            )
            .scaleEffect(scales[side, default: 1.0])
            .onTapGesture(count: 2) {
                pick(side)
            }
    }
    
    // Track rotation for 3D effect
    @State private var rotations: [VoteSide: Double] = [.left: 0, .right: 0]
    @State private var scales: [VoteSide: CGFloat] = [.left: 1.0, .right: 1.0]
    
    private func pick(_ side: VoteSide) {
        let loser: VoteSide = side == .left ? .right : .left
        let winner: VoteSide = side
        let fling = width * 1.5  // Slide further offscreen
        
        // Enhanced haptic feedback for voting
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        // Smooth spring animation for card exit
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            // Loser exits with rotation and slight scale reduction
            offsets[loser] = loser == .left ? -fling : fling
            rotations[loser] = loser == .left ? -10 : 10 // Rotate outward
            scales[loser] = 0.95  // Slightly smaller as it leaves
            
            // Winner gets subtle pulse
            scales[winner] = 1.05 // Slight grow effect
        }
        
        // Pulse back to normal size
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7).delay(0.2)) {
            scales[winner] = 1.0
        }
        
        // Wait longer before resetting for next card
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            // Reset positions for reuse
            offsets = [.left: 0, .right: 0]
            rotations = [.left: 0, .right: 0]
            scales = [.left: 1.0, .right: 1.0]
            onVote(side)
        }
    }
}