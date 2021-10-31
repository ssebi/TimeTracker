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
            .frame(width: 200, height: 100, alignment: .center)
            .background(Color.cGreen)
            .foregroundColor(.white)
            .cornerRadius(5)
            .font(.largeTitle .bold())
    }
}

struct AddBarButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 50, height: 25, alignment: .center)
            .background(Color.cGreen)
            .foregroundColor(.white)
            .cornerRadius(5)
            .font(.largeTitle .bold())
    }
}

struct SubmitButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 100, height: 30, alignment: .center)
            .background(Color.cGreen)
            .foregroundColor(.white)
            .cornerRadius(5)
            .font(.largeTitle .bold())
    }
}
