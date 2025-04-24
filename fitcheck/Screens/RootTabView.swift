import SwiftUI

/// The one and only root shown from `FitCheckApp`
struct RootTabView: View {
    
    enum Tab { case runway, crew, capture, rank, profile }
    @State private var tab: Tab = .runway
    @State private var previousTab: Tab = .runway
    
    // Track tab changes to remember previous tab
    private var tabBinding: Binding<Tab> {
        Binding(
            get: { tab },
            set: { newTab in
                // Store previous tab when switching to camera
                if newTab == .capture {
                    previousTab = tab
                }
                tab = newTab
            }
        )
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch tab {
                case .runway:
                    RunwayView()
                case .crew:
                    CrewView()
                case .capture:
                    CameraView(onBack: { tab = previousTab })
                case .rank:
                    RankingView()
                case .profile:
                    ClosetView()
                }
            }
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])

            if tab != .capture {
                CustomTabBar(selection: tabBinding)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: – Private
    
    /// Black background, bright-white selected, dim-white un-selected.
    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        // Create font descriptor for Cabinet Grotesk Medium
        let cabinetGroteskMedium = UIFont(name: "CabinetGrotesk-Medium", size: 10)!
        
        // Selected ≙ pure white with custom font
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: cabinetGroteskMedium
        ]
        
        // Un-selected ≙ 55 % white (matches header bar dimming) with custom font
        let dim = UIColor.white.withAlphaComponent(0.55)
        appearance.stackedLayoutAppearance.normal.iconColor  = dim
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: dim,
            .font: cabinetGroteskMedium
        ]
        
        UITabBar.appearance().standardAppearance     = appearance
        UITabBar.appearance().scrollEdgeAppearance   = appearance
    }
}

#Preview { RootTabView() }