//
//  LoginView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 12.10.2021.
//

import SwiftUI

struct LoginView: View {

    @State var username: String = ""
    @State var password: String = ""

    var body: some View {
        Image("timeTrackerIcon")
            .resizable()
            .frame(width: 200, height: 230, alignment: .center)

        Text("Time Tracker")
            .padding()
            .font(.title)
            .padding(.bottom, 40)
            .foregroundColor(Color.cBlack)

        Spacer()

        VStack {
            Group {
                TextField("E-mail", text: $username)
                    .padding()
                    .background(Color.cGray)
                    .cornerRadius(5.0)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.cGray)
                    .cornerRadius(5.0)
            }
            .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))

            Spacer()

            Button("Login", action: { })
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 45, height: 50, alignment: .center)
                .background(Color.cGreen)
                .cornerRadius(5)
                .padding(.bottom, 50)
        }
    }

}

struct LoginView_Previews: PreviewProvider {

    static var previews: some View {
        LoginView()
    }

}
