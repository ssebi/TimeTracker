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
            .frame(width: UIScreen.main.bounds.width - 55, height: 80, alignment: .center)
            .background(Color.cGreen)
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
