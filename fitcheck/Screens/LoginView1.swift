import SwiftUI
import PhoneNumberKit

struct LoginView1: View {
    // MARK: – Constants
    private let horizontalPadding: CGFloat = 20
    private let fieldWidth: CGFloat = 340
    private let barCorner: CGFloat = 14
    private let barHeight: CGFloat = 56

    // MARK: – Phone utilities
    private let phoneUtil = PhoneNumberUtility()
    private var regionID: String {
        if #available(iOS 16, *) { Locale.current.region?.identifier ?? "US" }
        else { Locale.current.regionCode ?? "US" }
    }
    private var dialPrefix: String { "+\(phoneUtil.countryCode(for: regionID) ?? 1)" }

    // MARK: – State
    @State private var phoneNumber = ""
    @FocusState private var phoneFieldFocused: Bool

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                TopBar(horizontalPadding: horizontalPadding)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        phoneNumberField

                        continueButton

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
        .onAppear { phoneFieldFocused = true }
    }

    // MARK: - Subviews
    private var phoneNumberField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Phone Number")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)

            HStack(spacing: 8) {
                Text(dialPrefix)
                    .font(.title2)
                    .foregroundColor(.gray)

                TextField("", text: $phoneNumber)
                    .font(.title2)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
                    .focused($phoneFieldFocused)
                    .autocorrectionDisabled()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .frame(maxWidth: fieldWidth)
            .background(
                RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                    .stroke(phoneFieldFocused ? .black : Color(white: 0.85), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                            .fill(Color(white: 0.98))
                    )
            )
            .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
        }
        .frame(maxWidth: .infinity)
    }

    private var continueButton: some View {
        Button("Continue") {
            // login action
        }
        .font(.custom("CabinetGrotesk-Bold", size: 22))
        .foregroundColor(.white)
        .frame(maxWidth: fieldWidth, minHeight: barHeight)
        .background(isContinueButtonEnabled ? Color.black : Color.gray)
        .cornerRadius(barCorner)
        .shadow(color: .black.opacity(0.09), radius: 8, y: 3)
        .accessibilityIdentifier("loginButton")
        .buttonStyle(PressableButtonStyle())
        .disabled(!isContinueButtonEnabled)
    }

    // Computed property to check if the button should be enabled
    private var isContinueButtonEnabled: Bool {
        !phoneNumber.isEmpty
    }
}

// MARK: - TopBar (Similar to LoginView2)
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

#Preview { LoginView1() }
