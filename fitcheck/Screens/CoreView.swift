import SwiftUI
import AVKit

struct CoreView: View {
    // MARK: – State
    @State private var selectedCategory: FeedCategory = .theme
    @State private var selectedCategoryText: String = FeedCategory.theme.rawValue
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background color (fallback when video isn't fully loaded)
                Color.black
                    .ignoresSafeArea(.container, edges: [.top, .horizontal])
                
                // Content area that changes based on selected category
                categoryContent
            }
            .overlay(alignment: .top) {
                // Category header bar that stays consistent across all views
                CategoryHeaderBar(selected: $selectedCategoryText)
                    .padding(.top, geo.safeAreaInsets.top + 12)
                    .onChange(of: selectedCategoryText) { oldValue, newValue in
                        // Update the enum value when text changes
                        if let newCategory = FeedCategory.allCases.first(where: { $0.rawValue == newValue }) {
                            selectedCategory = newCategory
                        }
                    }
            }
            .ignoresSafeArea(.container, edges: [.top, .horizontal])
        }
    }
    
    // MARK: - Category Content
    @ViewBuilder
    private var categoryContent: some View {
        switch selectedCategory {
        case .theme:
            ThemeView()
        case .city:
            CityView()
        case .runway:
            RunwayView()
        }
    }
}

/* ───────────── helpers ───────────── */

private extension Collection {
    /// Safe index access: `array[safe: 10]`
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview { CoreView() }