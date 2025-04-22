import SwiftUI

struct LoginView: View {
    @State private var phoneNumber: String = ""
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    Spacer().frame(height: geometry.size.height * 0.12)
                    Text("Log In")
                        .font(.custom("CabinetGrotesk-Regular", size: 30))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Spacer().frame(height: 40) // Doubled space

                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PHONE NUMBER")
                                .font(.custom("CabinetGrotesk-Bold", size: 12))
                                .foregroundColor(.gray)
                                .textCase(.uppercase)
                            TextField("", text: $phoneNumber)
                                .font(.system(size: 18)) // 25% larger than default
                                .keyboardType(.numberPad) // Show number pad keyboard
                                .padding(.bottom, 4)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.gray),
                                    alignment: .bottom
                                )
                        }

                    }
                    .padding(.horizontal, 60)
                    Spacer() // Placeholder for future content
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
