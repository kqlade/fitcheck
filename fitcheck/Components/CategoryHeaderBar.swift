import SwiftUI

struct CategoryHeaderBar: View {
    // MARK: – Constants
    private let categories = ["Theme"]
    private let repetitions = 10            // endless-scroll illusion
    private let barHeight: CGFloat = 44
    private let fadeWidth: CGFloat = 20

    @Binding var selected: String
    @Namespace private var underline
    @State   private var selectedIndex = 0

    /// Endless-scroll data source (cheap to recompute)
    private var repeated: [String] {
        (0..<repetitions).flatMap { _ in categories }
    }

    var body: some View {
        GeometryReader { geo in
            let barWidth = geo.size.width * 0.75   // adapts to size change
            
            // Center the bar by using HStack with spacers
            HStack {
                Spacer()
                ZStack {
                    // ── Background strip REMOVED for full transparency ──

                    // ── Scrollable pills ───────────────────────────────
                    ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { proxy in
                        HStack(spacing: 28) {
                            ForEach(Array(repeated.enumerated()), id: \.offset) { idx, cat in
                                pill(for: cat, selected: idx == selectedIndex)
                                    .id(idx)
                                    // ── FIX: tap wins the gesture race ─────────
                                    .highPriorityGesture(
                                        TapGesture().onEnded {
                                            updateSelection(
                                                to: idx,
                                                cat: cat,
                                                proxy: proxy
                                            )
                                        }
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        .onAppear {
                            centerInitialSelection(proxy: proxy)
                        }
                    }
                }
                .frame(width: barWidth, height: barHeight)
                .mask(edgeFade(width: barWidth))
                
                }
                .frame(width: barWidth, height: barHeight)
                Spacer()
            }
        }
        .frame(height: barHeight)
    }
}

// MARK: – Pill view
private struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let underline: Namespace.ID

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundColor(.white)
                .opacity(isSelected ? 1.0 : 0.7) // More contrast between selected/unselected

            if isSelected {
                Rectangle()
                    .fill(Color.white)
                    .matchedGeometryEffect(id: "underline", in: underline)
                    .frame(height: 2)
            } else {
                Color.clear.frame(height: 2)
            }
        }
        .padding(.vertical, 4)
        .accessibilityLabel(title)
    }
}

// MARK: – Helpers
private extension CategoryHeaderBar {
    @ViewBuilder
    func pill(for title: String, selected: Bool) -> some View {
        // Direct pill without the disabled button wrapper
        CategoryPill(title: title, isSelected: selected, underline: underline)
            .contentShape(Rectangle()) // ensure tappable area
            .accessibilityLabel(title)
    }

    func edgeFade(width: CGFloat) -> some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: .black, location: fadeWidth / width),
                .init(color: .black, location: 1 - fadeWidth / width),
                .init(color: .clear, location: 1)
            ],
            startPoint: .leading, endPoint: .trailing
        )
    }

    func centerInitialSelection(proxy: ScrollViewProxy) {
        if let first = repeated.firstIndex(of: selected) {
            let mid    = repeated.count / 2
            let target = mid + (first % categories.count)
            selectedIndex = target
            proxy.scrollTo(target, anchor: .center)
        }
    }

    func updateSelection(to idx: Int, cat: String, proxy: ScrollViewProxy) {
        // Set state immediately so visual changes happen instantly
        selected = cat
        selectedIndex = idx
        
        // Only animate the scroll
        withAnimation(.easeInOut(duration: 0.25)) {
            proxy.scrollTo(idx, anchor: .center)
        }
    }
}

/* ---------------- preview ---------------- */
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CategoryHeaderBar(selected: .constant("For You"))
    }
}