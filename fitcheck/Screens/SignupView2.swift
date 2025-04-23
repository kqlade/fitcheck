import SwiftUI
import PhoneNumberKit

struct SignupView2: View {
    // MARK: – Constants
    private let horizontalPadding: CGFloat = 20
    private let fieldWidth: CGFloat = 340
    private let barCorner: CGFloat = 14
    private let barHeight: CGFloat = 56

    // MARK: – Phone utilities (Copied from LoginView1)
    private let phoneUtil = PhoneNumberUtility()
    private var regionID: String {
        if #available(iOS 16, *) { Locale.current.region?.identifier ?? "US" }
        else { Locale.current.regionCode ?? "US" }
    }
    private var dialPrefix: String { "+\(phoneUtil.countryCode(for: regionID) ?? 1)" }

    // MARK: – State
    @State private var firstName = ""
    @State private var phoneNumber = ""
    @FocusState private var firstNameFocused: Bool
    @FocusState private var phoneNumberFocused: Bool

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                TopBar(horizontalPadding: horizontalPadding)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 36) {
                        usernameField

                        phoneNumberField

                        VStack(spacing: 24) {
                            helperText
                            continueButton
                        }
                        .padding(.top, 0)
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
        .onAppear { firstNameFocused = true }
    }

    private var usernameField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Username")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)

            HStack(spacing: 8) {
                TextField("", text: $firstName)
                    .font(.title2)
                    .keyboardType(.default)
                    .focused($firstNameFocused)
                    .autocorrectionDisabled()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .frame(maxWidth: fieldWidth)
            .background(
                RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                    .stroke(firstNameFocused ? .black : Color(white: 0.85), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                            .fill(Color(white: 0.98))
                    )
            )
            .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
        }
        .frame(maxWidth: .infinity)
    }

    private var phoneNumberField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Phone number")
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
                    .focused($phoneNumberFocused)
                    .autocorrectionDisabled()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .frame(maxWidth: fieldWidth)
            .background(
                RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                    .stroke(phoneNumberFocused ? .black : Color(white: 0.85), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                            .fill(Color(white: 0.98))
                    )
            )
            .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
        }
        .frame(maxWidth: .infinity)
    }

    private var helperText: some View {
        Text("By tapping \"Agree and Continue\" below, you agree to the Terms of Service and acknowledge that you have read the Privacy Policy.")
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: fieldWidth, alignment: .leading)
    }

    private var continueButton: some View {
        Button("Agree and Continue") {
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

    private var isContinueButtonEnabled: Bool {
        !firstName.isEmpty && !phoneNumber.isEmpty
    }
}

private struct TopBar: View {
    let horizontalPadding: CGFloat
    var body: some View {
        ZStack {
            Text("Create account")
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

#Preview { SignupView2() }
