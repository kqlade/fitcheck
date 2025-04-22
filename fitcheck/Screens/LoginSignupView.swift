import SwiftUI

struct LoginSignupView: View {
    // MARK: – Constants
    private let barHeight: CGFloat = 83
    private let heroAsset  = "snapChatGhost"
    private let loginColor = Color.pink
    private let signupColor = Color.blue

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.yellow
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Hero
                VStack {
                    Spacer()
                    Image(heroAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                    Spacer()
                }
                .frame(maxHeight: .infinity)

                // Action bars
                ActionBar(title: "LOG IN",
                          color: loginColor,
                          height: barHeight,
                          id: "loginButton") {
                    // TODO: login action
                }

                ActionBar(title: "SIGN UP",
                          color: signupColor,
                          height: barHeight,
                          id: "signupButton") {
                    // TODO: signup action
                }
            }
            .ignoresSafeArea(edges: .bottom)   // blue bar hugs bottom curve
        }
    }
}

private struct ActionBar: View {
    let title: String
    let color: Color
    let height: CGFloat
    let id: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("CabinetGrotesk-Bold", size: 24))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(color)
        }
        .accessibilityIdentifier(id)
    }
}

#Preview {
    LoginSignupView()
}
