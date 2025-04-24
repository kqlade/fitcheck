//
//  SignupView1.swift
//  FitCheck
//

import SwiftUI
import UserNotifications

struct SignupView1: View {
    // MARK: – Constants
    private let cardWidth:     CGFloat = 270
    private let cornerRadius:  CGFloat = 14
    private let ringScale:     CGFloat = 1.45          // base diameter multiplier
    private let topInset:      CGFloat = 22
    private let bottomInset:   CGFloat = 18
    private let labelSpacing:  CGFloat = 8
    private let buttonPadding: CGFloat = 10
    private let verticalOffset: CGFloat = 32

    private let dividerColor = Color.secondary.opacity(0.35)
    private let cardFill     = Color(white: 0.992)

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                Spacer()

                // MARK: Alert card
                VStack(spacing: 0) {
                    // Title + body
                    VStack(spacing: labelSpacing) {
                        Text("Please turn on Notifications")
                            .font(.system(size: 17, weight: .semibold))
                            .multilineTextAlignment(.center)

                        Text("You'll be able to see Fits from your friends on your phone.")
                            .font(.system(size: 13))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, topInset)
                    .padding(.bottom, bottomInset)
                    .padding(.horizontal, 24)

                    Rectangle()                       // horizontal divider
                        .fill(dividerColor)
                        .frame(height: 0.5)

                    // Buttons row
                    HStack(spacing: 0) {
                        alertButton("Don't Allow", id: "denyNotif")

                        Rectangle()                   // vertical divider
                            .fill(dividerColor)
                            .frame(width: 0.5)

                        alertButton("OK", id: "acceptNotif", ring: true) {
                            requestNotificationPermission()
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: cardWidth)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(cardFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(dividerColor, lineWidth: 1)
                )

                Spacer()
            }
            // vertical centring, safe on every device
            .padding(.bottom, UIApplication.shared.keyWindowSafeBottom + verticalOffset)
        }
    }

    // MARK: - Request Notification Permission
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    // Permission granted, continue to next step
                    print("Notification permission granted")
                    // Navigate to next screen here if needed
                } else {
                    // Handle rejection
                    print("Notification permission denied: \(error?.localizedDescription ?? "User denied")")
                }
            }
        }
    }
    
    // MARK: – Helper: one button
    @ViewBuilder
    private func alertButton(
        _ title: String,
        id: String,
        ring: Bool = false,
        action: @escaping () -> Void = {}
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: ring ? .semibold : .regular))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding(buttonPadding)
                .contentShape(Rectangle())
        }
        .background(ring ? BreathingHalo(scale: ringScale) : nil)
        .accessibilityIdentifier(id)
    }
}

/// Subtle breathing halo behind the OK button.
/// - Keeps the thin ring fixed.
/// - Animates a blurred glow from 0.8 → 1.0 opacity.
/// - Period: 1.6 s, easeInOut, autoreverse.
private struct BreathingHalo: View {
    let scale: CGFloat
    @State private var breathe = false

    var body: some View {
        GeometryReader { geo in
            // 1. Blurred glow (backmost layer)
            Circle()
                .fill(Color.blue.opacity(0.15))
                .frame(width: geo.size.height * scale * 1.05,
                       height: geo.size.height * scale * 1.05)
                .blur(radius: 4)
                .opacity(breathe ? 1.0 : 0.8)
                .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true),
                           value: breathe)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)

            // 2. Crisp ring on top
            Circle()
                .stroke(Color.blue, lineWidth: 2)
                .frame(width: geo.size.height * scale,
                       height: geo.size.height * scale)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
        .onAppear { breathe = true }
        .allowsHitTesting(false)
    }
}

// MARK: – Safe-area bottom helper
private extension UIApplication {
    var keyWindowSafeBottom: CGFloat {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets.bottom ?? 0
    }
}

#Preview { SignupView1() }