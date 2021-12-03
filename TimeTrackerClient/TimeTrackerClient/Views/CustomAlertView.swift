//
//  CustomAlertView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 03.12.2021.
//

import SwiftUI

struct CustomAlertView: View {
    @State var isValid = false
    @Binding var message: String

    var body: some View {
        VStack {
            Image(systemName: isValid ? "checkmark.circle.fill" : "x.circle.fill").resizable().frame(width: 50, height: 50).padding(.top, 25)
                .foregroundColor(isValid ? .green : .red)
                .background(Color.white)
                .mask(Circle().padding(.top, 25))
            Spacer()
            Text("\(message)").foregroundColor(Color.white).font(.title)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width-50, height: 200)
        .background(Color.gray.opacity(0.5).blur(radius: 10))
            .cornerRadius(12)
            .clipped()
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView( message: .constant("This is an error"))
    }
}
