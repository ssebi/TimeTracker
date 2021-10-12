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
        ZStack {
                 RoundedRectangle(cornerRadius: 25, style: .continuous)
                     .fill(Color.white)
                VStack {
                    Text("Time Tracker")
                        .padding()
                        .font(.title)
                        .padding(.bottom, 30)
                        .foregroundColor(Color.cBlack)
                    
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
                    Button("Login") { print("Loggin tapped") }
                          .foregroundColor(.white)
                          .frame(maxWidth: .infinity)
                          .background(Color.cGreen)
                          .cornerRadius(8)
                
                }
        
             }
             .frame(width: 450, height: 250)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
