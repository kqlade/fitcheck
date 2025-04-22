import SwiftUI
import PhoneNumberKit

struct SignupView2: View {
    // MARK: – Constants
    private let horizontalPadding: CGFloat = 20
    private let fieldWidth: CGFloat = 340
    private let barCorner: CGFloat = 14
    private let barHeight: CGFloat = 56


    // MARK: – State
    @State private var phoneNumber = ""
    @State private var phoneNumber2 = ""
    @FocusState private var phoneFieldFocused: Bool
    @FocusState private var phoneFieldFocused2: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: Title + Back
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

                Spacer().frame(height: 48)

                // MARK: Phone field
                VStack(alignment: .leading, spacing: 12) {
                    Text("First name")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)

                    HStack(spacing: 8) {
                        
                        TextField("", text: $phoneNumber)
                            .font(.title2)
                            .keyboardType(.default)
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

                Spacer().frame(height: 36)

                // MARK: Second Verification Code field
                VStack(alignment: .leading, spacing: 12) {
                    Text("Last name")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)

                    HStack(spacing: 8) {
                        TextField("", text: $phoneNumber2)
                            .font(.title2)
                            .keyboardType(.default)
                            .textContentType(.telephoneNumber)
                            .focused($phoneFieldFocused2)
                            .autocorrectionDisabled()
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 14)
                    .frame(maxWidth: fieldWidth)
                    .background(
                        RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                            .stroke(phoneFieldFocused2 ? .black : Color(white: 0.85), lineWidth: 1.5)
                            .background(
                                RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                                    .fill(Color(white: 0.98))
                            )
                    )
                    .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
                }
                .frame(maxWidth: .infinity)

                Spacer().frame(height: 36)
                Text("By tapping \"Agree and Continue\" below, you agree to the Terms of Service and acknowledge that you have read the Privacy Policy.")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: fieldWidth, alignment: .leading)
                Spacer().frame(height: 24)

                // MARK: Continue button
                Button("Agree and Continue") {
                    
                    // login action
                }
                .font(.custom("CabinetGrotesk-Bold", size: 22))
                .foregroundColor(phoneNumber.isEmpty ? .white : .white)
                .frame(maxWidth: fieldWidth, minHeight: barHeight)
                .background(phoneNumber.isEmpty ? Color.gray : Color.black)
                .cornerRadius(barCorner)
                .shadow(color: .black.opacity(0.09), radius: 8, y: 3)
                .padding(.top, 0)
                .accessibilityIdentifier("loginButton")
                .buttonStyle(PressableButtonStyle())

                Spacer(minLength: 0)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear { phoneFieldFocused = true }
    }
}

#Preview { SignupView2() }
