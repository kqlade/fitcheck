import SwiftUI

struct LoginSignupView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top section - 80% of screen height
                ZStack {
                    Color.yellow // Placeholder background color

                }
                .frame(height: geometry.size.height * 0.8)
                
                // Middle section - 10% of screen height
                Button(action: { /* login logic here */ }) {
                    Text("LOG IN")
                        .font(.custom("CabinetGrotesk-Extrabold", size: 22))
                        .foregroundColor(Color("WhiteBlackText"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(RowButtonStyle(normalColor: .red, pressedColor: .red.opacity(0.7)))
                .frame(height: geometry.size.height * 0.1)
                
                // Bottom section - 10% of screen height
                Button(action: { /* signup logic here */ }) {
                    Text("SIGN UP")
                        .font(.custom("CabinetGrotesk-Extrabold", size: 22))
                        .foregroundColor(Color("WhiteBlackText"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(RowButtonStyle(normalColor: .blue, pressedColor: .blue.opacity(0.7)))
                .frame(height: geometry.size.height * 0.1)
            }

        }
        .ignoresSafeArea() // This ensures the layout fills the full screen
    }
}

struct RowButtonStyle: ButtonStyle {
    var normalColor: Color
    var pressedColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? pressedColor : normalColor)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    LoginSignupView()
}
