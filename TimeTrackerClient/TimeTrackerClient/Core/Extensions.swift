//
//  Extensions.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 12.10.2021.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    static let cGray = Color("customGray")
    static let cGreen = Color("customGreen")
    static let cBlue = Color("customBlue")
    static let cBlack = Color("customBlack")
    static let caribeanGreen = Color("CaribbeanGreen")
    static let gradientTop = Color("backgroundGradientTop")
    static let gradientBottom = Color("backgroundGradientBottom")
    static let cWhite = Color("customWhite")
    static let shadow = Color("shadow")
    static let projectView = Color("projectView")
    static let projectViewBackground = Color("projectViewBackground")
    static let loginCard = Color("loginCard")
}

extension LinearGradient {
    static let gradientBackground = LinearGradient(gradient: Gradient(colors: [Color.gradientTop, Color.gradientBottom]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing)
}

extension UIScreen{
   static let width = UIScreen.main.bounds.size.width
   static let height = UIScreen.main.bounds.size.height
   static let size = UIScreen.main.bounds.size
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }

    func underlineTextField() -> some View {
            self
                .padding(.vertical, 10)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                .foregroundColor(.cGray)
                .padding(10)
        }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
