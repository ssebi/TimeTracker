//
//  Extensions.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 12.10.2021.
//

import Foundation
import SwiftUI

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
}
