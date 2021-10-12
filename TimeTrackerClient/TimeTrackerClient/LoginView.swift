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
        VStack{
            Text("Time Tracker")

            TextField("E-mail", text: $username)
                .padding()
                .background(.gray)
                .cornerRadius(5.0)
                .padding(10)
            SecureField("Password", text: $password)
                .padding()
                .background(.gray)
                .cornerRadius(5.0)
                .padding(10)
            Button("Login"){
                
               print("Loggin tapped")
            }
            .foregroundColor(.white)
            .buttonStyle(.bordered)
            .background(.blue)
            .frame(width: 300, height: 30, alignment: .center)
            .cornerRadius(5.0)
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
