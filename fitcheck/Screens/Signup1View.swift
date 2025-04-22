import SwiftUI
import UserNotifications

struct Signup1View: View {
    var body: some View {
        ZStack {
            Color.white               // leave the whole screen white
                .ignoresSafeArea()

            VStack {
                Spacer()

                // MARK: – Alert container
                VStack(spacing: 0) {

                    // Title + message
                    VStack(spacing: 8) {
                        Text("Please turn on Notifications")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)

                        Text("You'll be able to see Fits from your friends on your phone.")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 22)
                    .padding(.bottom, 18)

                    // Thin divider above the button row
                    Rectangle()
                        .fill(Color(white: 0.85))
                        .frame(height: 0.5)

                    // MARK: – Buttons row
                    HStack(spacing: 0) {

                        // “Don’t Allow”
                        Button(action: {}) {
                            Text("Don't Allow")
                                .font(.system(size: 17))
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                        }

                        // Vertical divider between the two buttons
                        Rectangle()
                            .fill(Color(white: 0.85))
                            .frame(width: 0.5)

                        // “OK” + blue ring highlight
                        Button(action: {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                                // Optionally handle the result here
                            }
                        }) {
                            Text("OK")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                        }
                        .overlay(
                            GeometryReader { geo in
                                Circle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(
                                        width: geo.size.height * 1.45,
                                        height: geo.size.height * 1.45
                                    )
                                    .position(
                                        x: geo.size.width  / 2,
                                        y: geo.size.height / 2
                                    )
                            }
                        )
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: 270)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(white: 0.992))
                )
                .overlay(                                  // faint outer border
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(white: 0.85), lineWidth: 1)
                )

                Spacer()
            }
            .padding(.bottom, 80)       // centres it vertically like the screenshot
        }
    }
}

#Preview {
    Signup1View()
}
