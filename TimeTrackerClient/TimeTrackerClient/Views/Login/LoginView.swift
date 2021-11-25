//
//  LoginView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 12.10.2021.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var loginVM = LoginViewModel()

    var body: some View {
        ScrollView {
            ZStack {
                VStack {

                    Image("timeTrackerIcon")
                        .resizable()
                        .frame(width: 200, height: 230, alignment: .center)

                    Text("Time Tracker")
                        .padding()
                        .font(.title)
                        .padding(.bottom, 40)
                        .foregroundColor(Color.cBlack)

                    Spacer()

                    Group {
                        TextField("E-mail", text: $loginVM.username)
                            .padding()
                            .background(Color.cGray)
                            .cornerRadius(5.0)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        SecureField("Password", text: $loginVM.password)
                            .padding()
                            .background(Color.cGray)
                            .cornerRadius(5.0)
                    }
                    .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
                    Spacer()
                    Button(action: {
                        signIn()
                    }) {
                        Text("Login")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(width: UIScreen.main.bounds.width - 45, height: 50, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.cGreen)
                    .cornerRadius(5)
                    .padding(.bottom, 50)
                }
                if (loginVM.isLoading) {
                    ProgressIndicator()
                }
            }
        }
    }

    func signIn() {
        session.signIn(email: loginVM.username, password: loginVM.password){ _ in }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginVM: LoginViewModel())
    }
}
