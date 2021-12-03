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
            .background(LinearGradient.gradientBackground)
            .foregroundColor(.white)
            .cornerRadius(5)
            .font(Font.custom("Avenir-Next", size: 30))
    }
}

struct Path {
    static let clients = "Clients"
    static let timeSlot = "timeSlots"
}



