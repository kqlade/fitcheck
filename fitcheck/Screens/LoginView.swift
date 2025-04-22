//
//  LoginView.swift
//  FitCheck
//
//  Created by ChatGPT on 22 Apr 2025.
//

import SwiftUI
import PhoneNumberKit

struct LoginView: View {

    // MARK: – Phone utilities
    private let phoneUtil = PhoneNumberUtility()

    /// ISO‑3166 region string (e.g. “US”), always non‑empty.
    private let regionID: String = {
        if #available(iOS 16, *) {
            Locale.current.region?.identifier ?? "US"
        } else {
            Locale.current.regionCode ?? "US"
        }
    }()

    /// “+1”, “+44”, etc.—falls back to US (+1) if lookup fails.
    private var dialPrefix: String { "+\(phoneUtil.countryCode(for: regionID) ?? 1)" }

    // MARK: – State
    @State private var phoneNumber      = ""
    @State private var keyboardHeight: CGFloat = 0      // only used on iOS 14

    // MARK: – Body
    var body: some View {
        GeometryReader { geo in
            Color.white.ignoresSafeArea()

            // Back chevron
            Button(action: { /* navigate back */ }) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            // Main content
            VStack {
                Spacer().frame(height: geo.size.height * 0.12)

                Text("Log In")
                    .font(.custom("CabinetGrotesk-Regular", size: 36))

                Spacer().frame(height: 40)

                VStack(alignment: .leading, spacing: 12) {
                    Text("PHONE NUMBER")
                        .font(.custom("CabinetGrotesk-Bold", size: 18))
                        .foregroundColor(.gray)
                        .textCase(.uppercase)

                    HStack {
                        Text(dialPrefix)
                            .font(.custom("CabinetGrotesk-Regular", size: 24))
                        TextField("", text: $phoneNumber)
                            .font(.custom("CabinetGrotesk-Regular", size: 24))
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                            .autocorrectionDisabled()
                    }
                    .padding(.bottom, 4)
                    .overlay(Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray),
                             alignment: .bottom)
                }
                .padding(.horizontal, 60)

                Spacer()
            }
            // Floating login button (native safe‑area inset ≥ iOS 15, manual on 14)
            .modifier(FloatingLoginButton(keyboardHeight: $keyboardHeight,
                                          safeBottom: geo.safeAreaInsets.bottom))
        }
        .onAppear {
            // Keyboard tracking only required on iOS 14 and below
            if #unavailable(iOS 15) { observeKeyboard() }
        }
        .onDisappear {
            if #unavailable(iOS 15) {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }

    // MARK: – Legacy keyboard observers (iOS 14)
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: .main) { notif in
            updateKeyboardHeight(from: notif)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil,
                                               queue: .main) { notif in
            updateKeyboardHeight(from: notif)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: .main) { _ in
            keyboardHeight = 0
        }
    }

    /// Reads the keyboard frame and converts it to on‑screen height.
    private func updateKeyboardHeight(from notif: Notification) {
        guard
            let frame = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
            let window = windowScene.windows.first(where: \.isKeyWindow)
        else { return }

        keyboardHeight = max(frame.height - window.safeAreaInsets.bottom, 0)
    }
}

// MARK: – Floating login button modifier

private struct FloatingLoginButton: ViewModifier {
    @Binding var keyboardHeight: CGFloat
    var safeBottom: CGFloat                    // passed from GeometryReader

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            content
                .safeAreaInset(edge: .bottom) {
                    loginButton
                        .padding(.vertical, 24)
                }
        } else {
            content
                .overlay(
                    VStack {
                        Spacer()
                        loginButton
                            .padding(.bottom,
                                     max(safeBottom + 24, keyboardHeight + 16))
                            .animation(.easeOut(duration: 0.25), value: keyboardHeight)
                    }
                )
        }
    }

    private var loginButton: some View {
        Button(action: { /* login */ }) {
            Image(systemName: "arrow.right")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 64, height: 64)
                .background(Color.black)
                .clipShape(Circle())
        }
    }
}

// MARK: – Preview

#Preview { LoginView() }
