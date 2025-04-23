import SwiftUI

/// The one and only root shown from `FitCheckApp`
struct RootTabView: View {
    
    enum Tab { case home, friends, capture, inbox, profile }
    @State private var tab: Tab = .home
    
    var body: some View {
        TabView(selection: $tab) {
            // ─────────── HOME / FEED ──────────────────────────────
            CoreView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.home)
            
            // ─────────── FRIENDS (stub) ──────────────────────────
            Color.black.opacity(0.001)
                .tabItem { Label("Friends", systemImage: "person.2") }
                .tag(Tab.friends)
            
            // ─────────── CAPTURE “+” (stub) ──────────────────────
            Color.black.opacity(0.001)
                .tabItem { Label("Capture", systemImage: "plus") }
                .tag(Tab.capture)
            
            // ─────────── INBOX (stub) ────────────────────────────
            Color.black.opacity(0.001)
                .tabItem { Label("Inbox", systemImage: "bubble.right") }
                .tag(Tab.inbox)
            
            // ─────────── PROFILE (stub) ──────────────────────────
            Color.black.opacity(0.001)
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(Tab.profile)
        }
        .onAppear(perform: configureTabBar)   // ← single, one-time hook
        .preferredColorScheme(.dark)          // light status-bar text
    }
    
    // MARK: – Private
    
    /// Black background, bright-white selected, dim-white un-selected.
    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        // Selected ≙ pure white
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        // Un-selected ≙ 55 % white (matches header bar dimming)
        let dim = UIColor.white.withAlphaComponent(0.55)
        appearance.stackedLayoutAppearance.normal.iconColor  = dim
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: dim
        ]
        
        UITabBar.appearance().standardAppearance     = appearance
        UITabBar.appearance().scrollEdgeAppearance   = appearance
    }
}

#Preview { RootTabView() }