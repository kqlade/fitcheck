import SwiftUI

/// Shows the theme feed, but scoped to friends/crew only.
struct CrewView: View {
    // TODO: Replace posts with only friends' posts when backend is ready
    var body: some View {
        ThemeView() // Reuse existing theme feed for now
    }
}

#Preview {
    CrewView()
}
