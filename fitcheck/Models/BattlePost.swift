import Foundation

struct BattlePost: Identifiable, Equatable {
    let id: String              // same as Post.id
    var post: Post
    var wins: Int = 0           // consecutive wins counter
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}
