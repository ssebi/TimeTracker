//
//  Utils.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import Foundation
import SwiftUI

struct AddButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: UIScreen.main.bounds.width - 55, height: 50, alignment: .center)
            .background(LinearGradient.gradientButton)
            .foregroundColor(.white)
            .cornerRadius(5)
            .font(.largeTitle .bold())
    }
}

extension UIScreen{
   static let width = UIScreen.main.bounds.size.width
   static let height = UIScreen.main.bounds.size.height
   static let size = UIScreen.main.bounds.size
}

struct Path {
    static let clients = "Clients"
    static let timeSlot = "timeSlots"
}

extension LinearGradient {
    static let gradientButton = LinearGradient(gradient: Gradient(colors: [Color.caribeanGreen, Color.cBlue]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing)
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}
