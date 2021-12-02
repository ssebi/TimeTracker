//
//  LoginFormView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.12.2021.
//

import SwiftUI

struct LoginFormView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel

    var body: some View {
        VStack{
            VStack{
                Text("Login with your")
                HStack{
                    Text("TIME")
                    Text("TRACKER").bold()
                    Text("account")
                }
            }
            .foregroundColor(Color.cBlack)
            .font(Font.custom("Avenir-Light", size: 20.0))

            Group {
                Text("\(viewModel.errrorMessage)")
                    .foregroundColor(.red)
                    .font(Font.custom("Avenir-Light", size: 20))
                    .padding()
                HStack {
                    Image(systemName: "person.fill")
                    TextField("", text: $viewModel.username)
                        .placeholder(when: viewModel.password.isEmpty) {
                            Text("E-mail").foregroundColor(.cGray)
                        }
                        .cornerRadius(10)
                        .foregroundColor(.cBlack)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onTapGesture {
                            viewModel.errrorMessage = ""
                        }
                }.underlineTextField()

                HStack {
                    Image(systemName: "lock.fill")
                    SecureField("", text: $viewModel.password)
                        .placeholder(when: viewModel.password.isEmpty) {
                            Text("Password").foregroundColor(.cGray)
                        }
                        .foregroundColor(.cBlack)
                        .cornerRadius(10)
                        .onTapGesture {
                            viewModel.errrorMessage = ""
                        }
                }.underlineTextField()
            }
            .padding(EdgeInsets(top: 1, leading: 45, bottom: 1, trailing: 45))

            Section {
                Button(action: {
                    viewModel.signIn()
                }) {
                    Text("Login")
                        .font(Font.custom("Avenir-Light", size: 25))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(width: UIScreen.main.bounds.width - 95, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(LinearGradient.gradientBackground)
                .cornerRadius(30)
                .padding(EdgeInsets(top: 50, leading: 45, bottom: 1, trailing: 45))
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 2) - 10, alignment: .center)
    }
}

struct LoginFormView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider())))
    }
}
