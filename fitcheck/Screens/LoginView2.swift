import SwiftUI
import PhoneNumberKit

struct LoginView2: View {
    // MARK: – Constants
    private let horizontalPadding: CGFloat = 20
    private let fieldWidth: CGFloat = 340
    private let barCorner: CGFloat = 14
    private let barHeight: CGFloat = 56

    // MARK: – State
    @State private var verificationCode = ""
    @FocusState private var codeFieldFocused: Bool

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                TopBar(horizontalPadding: horizontalPadding)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        verificationCodeField

                        verifyButton

                        resendCodeButton

                        Spacer(minLength: 0)
                    }
                    .padding(.top, 48)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, geo.safeAreaInsets.bottom)
                    .frame(maxWidth: .infinity)
                }
                .scrollDismissesKeyboard(.interactively)
                .ignoresSafeArea(.keyboard)
            }
            .background(Color(.systemBackground).ignoresSafeArea())
        }
        .onAppear { codeFieldFocused = true }
    }

    // MARK: - Subviews
    private var verificationCodeField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Verification Code")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)

            HStack(spacing: 8) {
                TextField("", text: $verificationCode)
                    .font(.title2)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($codeFieldFocused)
                    .autocorrectionDisabled()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .frame(maxWidth: fieldWidth)
            .background(
                RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                    .stroke(codeFieldFocused ? .black : Color(white: 0.85), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                            .fill(Color(white: 0.98))
                    )
            )
            .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
        }
        .frame(maxWidth: .infinity)
    }

    private var verifyButton: some View {
        Button("Verify") {
            // login action
        }
        .font(.custom("CabinetGrotesk-Bold", size: 22))
        .foregroundColor(.white)
        .frame(maxWidth: fieldWidth, minHeight: barHeight)
        .background(Color.black)
        .cornerRadius(barCorner)
        .shadow(color: .black.opacity(0.09), radius: 8, y: 3)
        .accessibilityIdentifier("loginButton")
        .buttonStyle(PressableButtonStyle())
    }

    private var resendCodeButton: some View {
        Button("Resend code") {
            // Resend code action
        }
        .font(.system(size: 15, weight: .semibold))
        .foregroundColor(.black)
    }
}

// MARK: - TopBar
private struct TopBar: View {
    let horizontalPadding: CGFloat
    var body: some View {
        ZStack {
            Text("Log in")
                .font(.custom("CabinetGrotesk-Bold", size: 34))
                .foregroundColor(.black)

            HStack {
                Button(action: { /* navigate back */ }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
                .accessibilityIdentifier("backButton")
                Spacer()
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, horizontalPadding)
        .frame(maxWidth: .infinity)
    }
}

#Preview { LoginView2() }
