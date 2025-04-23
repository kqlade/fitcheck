import SwiftUI

struct SignupView3: View {
    // ── constants (aligned with LoginView2) ───────────────────────────────────────────────
    private let horizontalPadding: CGFloat = 20
    private let fieldWidth: CGFloat = 340
    private let barCorner: CGFloat = 14 // Renamed from corner
    private let barHeight: CGFloat = 56 // Renamed from ctaHeight

    // ── state (aligned with LoginView2) ───────────────────────────────────────────────────
    @State private var verificationCode = "" // Renamed from code
    @FocusState private var codeFieldFocused: Bool // Renamed from fieldFocused

    var body: some View {
        GeometryReader { geo in                       // we need safe-bottom inset
            VStack(spacing: 0) {

                // 1. Fixed top bar
                TopBar(horizontalPadding: horizontalPadding)

                // 2. Scrollable form
                ScrollView(.vertical, showsIndicators: false) {
                    // Use single VStack with spacing 24, like LoginView2
                    VStack(spacing: 24) {

                        verificationField

                        // Buttons directly in the VStack
                        verifyButton
                        resendButton

                        Spacer(minLength: 0) // Keep spacer to push up
                    }
                    .padding(.top, 48)                // gap below title
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, geo.safeAreaInsets.bottom) // clears home-indicator
                    .frame(maxWidth: .infinity)
                }
                .scrollDismissesKeyboard(.interactively)
                .ignoresSafeArea(.keyboard)           // scroll can extend under kb
            }
            .background(Color(.systemBackground).ignoresSafeArea())
        }
        .onAppear { codeFieldFocused = true } // Use renamed state
    }

    // ── subviews ────────────────────────────────────────────────
    private var verificationField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Verification Code")
                .font(.system(size: 17, weight: .semibold))

            TextField("", text: $verificationCode) // Use renamed state
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode) // Add textContentType
                .font(.title2)
                .padding(.vertical, 14)
                .padding(.horizontal, 14)
                .frame(maxWidth: fieldWidth)
                .background(
                    RoundedRectangle(cornerRadius: barCorner) // Use renamed constant
                        .stroke(codeFieldFocused ? .black : Color(white: 0.85), lineWidth: 1.5)
                        .background(
                            RoundedRectangle(cornerRadius: barCorner) // Use renamed constant
                                .fill(Color(white: 0.98))
                        )
                )
                .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
                .focused($codeFieldFocused) // Use renamed state
        }
        .frame(maxWidth: .infinity)
    }

    private var verifyButton: some View {
        Button("Verify") { /* verify */ }
            .font(.custom("CabinetGrotesk-Bold", size: 22))
            .foregroundColor(.white)
            .frame(maxWidth: fieldWidth, minHeight: barHeight) // Use renamed constant
            .background(isContinueButtonEnabled ? Color.black : Color.gray)
            .cornerRadius(barCorner) // Use renamed constant
            .shadow(color: .black.opacity(0.09), radius: 8, y: 3)
            .buttonStyle(PressableButtonStyle())
            .disabled(!isContinueButtonEnabled)
            .accessibilityIdentifier("verifyButton")
    }

    private var resendButton: some View {
        Button("Resend code") { /* resend */ }
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.black)
            .accessibilityIdentifier("resendCodeButton")
    }

    private var isContinueButtonEnabled: Bool {
        !verificationCode.isEmpty
    }
}

// Fixed title bar
private struct TopBar: View {
    let horizontalPadding: CGFloat
    var body: some View {
        ZStack {
            // Wrap title and subtitle in a VStack
            VStack(spacing: 2) {
                Text("Create account")
                    .font(.custom("CabinetGrotesk-Bold", size: 34))
                    .foregroundColor(.black)

                Text("Step 2 of 3") // Add subtitle
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray)
            }

            HStack {
                Button { /* back */ } label: {
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

#Preview { SignupView3() }
