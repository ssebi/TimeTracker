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
    @State var username: String = ""
    @State var password: String = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
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
                        TextField("E-mail", text: $username )
                            .padding()
                            .background(Color.cGray)
                            .cornerRadius(5.0)
                            .accentColor(.white)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.cGray)
                            .accentColor(.white)
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

                if loginVM.isLoading {
                    ProgressIndicator()
                }
            }
        }
    }

    func signIn() {
        loginVM.isLoading = true
        session.signIn(email: username, password: password){ _ in
            loginVM.isLoading = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginVM: LoginViewModel())
    }
}
