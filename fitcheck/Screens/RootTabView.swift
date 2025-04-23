import SwiftUI

/// The one and only root shown from `FitCheckApp`
struct RootTabView: View {
    
    enum Tab { case runway, crew, capture, chat, profile }
    @State private var tab: Tab = .runway
    
    var body: some View {
        TabView(selection: $tab) {
            // ─────────── RUNWAY / FEED ──────────────────────────────
            CoreView()
                .tabItem { Label("Runway", systemImage: "house") }
                .tag(Tab.runway)
            
            // ─────────── CREW (friends-only feed) ──────────────────────────
            CrewView()
                .tabItem { Label("Crew", systemImage: "person.2") }
                .tag(Tab.crew)
            
            // ─────────── CAPTURE “+” (stub) ──────────────────────
            Color.black.opacity(0.001)
                .tabItem { Label("Capture", systemImage: "plus") }
                .tag(Tab.capture)
            
            // ─────────── CHAT (stub) ────────────────────────────
            Color.black.opacity(0.001)
                .tabItem { Label("Chat", systemImage: "bubble.right") }
                .tag(Tab.chat)
            
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