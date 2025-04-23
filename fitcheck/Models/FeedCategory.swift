import SwiftUI

/// Defines the main categories in the app feed
enum FeedCategory: String, CaseIterable, Identifiable {
    case theme = "Theme"
    case city = "City" 
    
    var id: String { rawValue }
    
    /// Default starting category
    static var `default`: FeedCategory { .theme }
}
