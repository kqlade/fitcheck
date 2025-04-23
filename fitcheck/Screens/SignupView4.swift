import SwiftUI
import PhoneNumberKit

struct SignupView4: View {
    // MARK: – Constants
    private let horizontalPadding: CGFloat = 20
    private let fieldWidth: CGFloat = 340
    private let barCorner: CGFloat = 14
    private let barHeight: CGFloat = 56

    // MARK: – Date Formatter
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // e.g., "Apr 22, 2025"
        formatter.timeStyle = .none
        // Consider setting locale: formatter.locale = Locale(identifier: "en_US_POSIX")
        // Consider setting lenient: formatter.isLenient = true // Allows slightly malformed input
        return formatter
    }()

    // MARK: – State
    @State private var birthDate: Date = Date()
    @State private var birthDateString: String = "" // State for TextField string
    @FocusState private var birthdayFieldFocused: Bool // Renamed focus state

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // MARK: Title + Back (Now using extracted TopBar)
                TopBar(horizontalPadding: horizontalPadding)

                // 2. Scrollable content (like SignupView3)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 36) { // Use VStack for spacing content

                        // MARK: Birthday field (Connected TextField)
                        birthdayField // Use extracted subview

                        // MARK: Continue button
                        continueButton // Use extracted subview

                        // MARK: Date Picker
                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                            .frame(maxWidth: fieldWidth)
                            .labelsHidden()
                            .padding(.top, -12) // Adjust spacing relative to button

                    }
                    .padding(.top, 48)                // Gap below title bar
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, geo.safeAreaInsets.bottom) // Clears home-indicator
                    .frame(maxWidth: .infinity)
                }
                // Apply scroll modifiers for consistency, even if keyboard isn't main focus yet
                .scrollDismissesKeyboard(.interactively)
                .ignoresSafeArea(.keyboard)
            }
            .background(Color(.systemBackground).ignoresSafeArea()) // Apply background here
        }
        .onAppear { // Update string initially and focus
            birthDateString = dateFormatter.string(from: birthDate)
            birthdayFieldFocused = true
        }
        .onChange(of: birthDate) { newDate in // DatePicker changes -> Update TextField String
            birthDateString = dateFormatter.string(from: newDate)
        }
        .onChange(of: birthDateString) { newString in // TextField changes -> Try to update DatePicker Date
            if let date = dateFormatter.date(from: newString) {
                // Optional: Check if date differs significantly to avoid tiny loops
                // if abs(date.timeIntervalSince(birthDate)) > 1 { // e.g., more than 1 second difference
                    birthDate = date
                // }
            } // else: input is invalid, DatePicker doesn't change
        }
    }

    // MARK: - Subviews
    private var birthdayField: some View { // Extracted Birthday Field
        VStack(alignment: .leading, spacing: 12) {
            Text("Birthday")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)

            HStack(spacing: 8) {
                TextField("MM/DD/YYYY", text: $birthDateString) // Bind to string state
                    .font(.title2)
                    .keyboardType(.numbersAndPunctuation) // Allow manual date entry
                    // .textContentType(.dateTime) // Might help with suggestions?
                    .focused($birthdayFieldFocused) // Use new focus state
                    .autocorrectionDisabled()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .frame(maxWidth: fieldWidth)
            .background(
                RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                    .stroke(birthdayFieldFocused ? .black : Color(white: 0.85), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: barCorner, style: .continuous)
                            .fill(Color(white: 0.98))
                    )
            )
            .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
        }
        .frame(maxWidth: .infinity)
    }

    private var continueButton: some View { // Extracted Button
        Button("Sign up") { // Changed text from "Continue"
            // signup action - should finalize account creation
        }
        .font(.custom("CabinetGrotesk-Bold", size: 22))
        .foregroundColor(.white)
        .frame(maxWidth: fieldWidth, minHeight: barHeight)
        .background(isSignUpButtonEnabled ? Color.black : Color.gray)
        .cornerRadius(barCorner)
        .shadow(color: .black.opacity(0.09), radius: 8, y: 3)
        .accessibilityIdentifier("loginButton")
        .buttonStyle(PressableButtonStyle())
        .disabled(!isSignUpButtonEnabled) // Add disabled modifier
    }

    // Computed property to check if the button should be enabled
    private var isSignUpButtonEnabled: Bool {
        birthDate != nil // Enable only if birthDate is selected
    }
}

// MARK: - TopBar (extracted like SignupView3)
private struct TopBar: View {
    let horizontalPadding: CGFloat
    var body: some View {
        ZStack {
            // Wrap title and subtitle in a VStack
            VStack(spacing: 2) {
                Text("Create account")
                    .font(.custom("CabinetGrotesk-Bold", size: 34))
                    .foregroundColor(.black)

                Text("Step 3 of 3") // Add subtitle
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray)
            }

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

#Preview { SignupView4() }
