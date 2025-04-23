import SwiftUI
import PhoneNumberKit          // Remove if genuinely unused

struct SignupView4: View {
    // MARK: – Constants
    private let horizontalPadding: CGFloat = 20
    private let fieldWidth: CGFloat        = 340
    private let barCorner: CGFloat         = 14
    private let barHeight: CGFloat         = 56

    // MARK: – Date Formatter
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle    = .medium
        f.timeStyle    = .none
        f.locale       = Locale(identifier: "en_US_POSIX")
        f.isLenient    = true
        return f
    }()

    // MARK: – State
    @State private var birthDate: Date = Date()
    @State private var birthDateString = ""
    @FocusState private var birthdayFocused: Bool        // ← removed “= false”

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                TopBar(horizontalPadding: horizontalPadding)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 36) {
                        birthdayField
                        continueButton
                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .frame(maxWidth: fieldWidth)
                            .labelsHidden()
                            .padding(.top, -12)
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
        .onAppear {
            birthDateString = dateFormatter.string(from: birthDate)
            birthdayFocused = true
        }
        .onChange(of: birthDate) {
            birthDateString = dateFormatter.string(from: birthDate)
        }
        .onChange(of: birthDateString) {
            if let parsed = dateFormatter.date(from: birthDateString) {
                birthDate = parsed
            }
        }
    }

    // MARK: – Subviews
    private var birthdayField: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Birthday")
                .font(.system(size: 17, weight: .semibold))

            TextField("MM/DD/YYYY", text: $birthDateString)
                .font(.title2)
                .keyboardType(.numbersAndPunctuation)
                .focused($birthdayFocused)
                .autocorrectionDisabled()
                .padding(.vertical, 14)
                .padding(.horizontal, 14)
                .frame(maxWidth: fieldWidth)
                .background(
                    RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                        .stroke(birthdayFocused ? .black : Color(white: 0.85), lineWidth: 1.5)
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
        Button("Sign up") {
            // Finalize account creation
        }
        .font(.custom("CabinetGrotesk-Bold", size: 22))
        .foregroundColor(.white)
        .frame(maxWidth: fieldWidth, minHeight: barHeight)
        .background(isSignUpButtonEnabled ? .black : .gray)
        .cornerRadius(barCorner)
        .shadow(color: .black.opacity(0.09), radius: 8, y: 3)
        .accessibilityIdentifier("loginButton")
        .buttonStyle(PressableButtonStyle())
        .disabled(!isSignUpButtonEnabled)
    }

    private var isSignUpButtonEnabled: Bool {
        dateFormatter.date(from: birthDateString) != nil
    }
}

// MARK: – Top Bar
private struct TopBar: View {
    let horizontalPadding: CGFloat
    var body: some View {
        ZStack {
            VStack(spacing: 2) {
                Text("Create account")
                    .font(.custom("CabinetGrotesk-Bold", size: 34))
                Text("Step 3 of 3")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            HStack {
                Button(action: { /* navigate back */ }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 24, weight: .bold))
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

#Preview { SignupView4() }
