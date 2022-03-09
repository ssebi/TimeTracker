//
//  SignUp.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.03.2022.
//

import SwiftUI
import TimeTrackerAuth
import TimeTrackerCore

struct SignUpView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel
    @State private var isSecured: Bool = true
    
    var body: some View {
        VStack {
            Group {
                Text("Create a new account")
                    .foregroundColor(.cBlack)
                    .font(Font.custom("Avenir-Light", size: 20.0))

                Text("\(viewModel.errrorMessage)")
                    .foregroundColor(.red)
                    .font(Font.custom("Avenir-Light", size: 20))
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 60, alignment: .center)

                HStack {
                    Image(systemName: "person.fill")
                    TextField("E-mail", text: $viewModel.username)
                        .foregroundColor(.cBlack)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .onTapGesture {
                            viewModel.errrorMessage = ""
                        }
                }.underlineTextField()
                    .padding()

                HStack {
                    Image(systemName: "lock.fill")
                    ZStack(alignment: .trailing) {
                        if isSecured {
                            SecureField("Password", text: $viewModel.password)
                                .foregroundColor(.cBlack)
                                .autocapitalization(.none)
                                .onTapGesture {
                                    viewModel.errrorMessage = ""
                                }
                        } else {
                            TextField("Password", text: $viewModel.password)
                                .foregroundColor(.cBlack)
                                .textContentType(.password)
                                .autocapitalization(.none)
                                .onTapGesture {
                                    viewModel.errrorMessage = ""
                                }
                        }
                        Button(action: {
                            isSecured.toggle()
                        }) {
                            Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                .accentColor(.cGray)
                        }
                    }
                }.underlineTextField()
                    .padding()
            }
            .padding(EdgeInsets(top: 20, leading: 45, bottom: 10, trailing: 45))
            .frame(height: 50, alignment: .center)

            Section {
                Button(action: {
                    viewModel.createAccount()
                }) {
                    Text("Create account")
                        .font(Font.custom("Avenir-Light", size: 25))
                        .frame(maxWidth: .infinity, alignment: .center)
                }.buttonStyle(SubmitButton())
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider()), userLoader: FirebaseUserLoader()))
    }
}
