import SwiftUI

struct CustomTabBar: View {

    @Binding var selection: RootTabView.Tab
    
    /// (tab, title, SF Symbol)
    private let tabs: [(RootTabView.Tab, String, String)] = [
        (.runway , "Runway" , "sparkles"),
        (.crew   , "Crew"   , "person.2"),
        (.capture, "Camera" , "camera"),
        (.rank   , "Rank"   , "trophy"),
        (.profile, "Closet" , "tshirt")
    ]
    
    // Icon + label sizes
    private enum C {
        static let iconSize: CGFloat = 22
        static let fontSize: CGFloat = 11     // tweak until baseline matches TikTok
    }
    
    var body: some View {
        GeometryReader { geo in
            let horizontalInset = geo.size.width * 0.05      // 5 % side inset
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.0) { tab, label, sfName in
                    Button { selection = tab } label: {
                        VStack(spacing: 4) {
                            Image(systemName:
                                (tab == .profile && selection == tab) ? "tshirt.fill" :
                                (tab == .crew && selection == tab) ? "person.2.fill" :
                                (tab == .capture && selection == tab) ? "camera.fill" :
                                (tab == .rank && selection == tab) ? "trophy.fill" :
                                (tab == .profile) ? "tshirt" :
                                (tab == .crew) ? "person.2" :
                                (tab == .capture) ? "camera" :
                                (tab == .rank) ? "rosette" :
                                sfName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: C.iconSize, height: C.iconSize)
                                .fontWeight(selection == tab ? .bold : .regular)
                                .foregroundColor(selection == tab
                                                 ? .white
                                                 : .white.opacity(0.55))
                                .padding(.top, 6) // Move icon down
                            
                            Text(label)
                                .font(.custom("CabinetGrotesk-Medium", size: C.fontSize))
                                .lineLimit(1)
                                .foregroundColor(selection == tab
                                                 ? .white
                                                 : .white.opacity(0.55))
                        }
                        .frame(maxWidth: .infinity)           // equal width tap-targets
                        .contentShape(Rectangle())            // reliable hit-area
                    }
                }
            }
            .padding(.horizontal, horizontalInset)
            .padding(.top, 6)                                 // icon–top spacing
            .padding(.bottom, max(geo.safeAreaInsets.bottom, 12))
            .background(Color.black.ignoresSafeArea(edges: .bottom))
        }
        .frame(height: 60)                                    // bar height incl. padding
    }
}

#Preview {
    CustomTabBar(selection: .constant(.runway))
        .background(Color.black)
}
