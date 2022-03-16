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
            ScrollView{
            Group {
                Text("Create a new account")
                    .foregroundColor(.cBlack)
                    .font(Font.custom("Avenir-Light", size: 20.0))

                Text("under \(viewModel.manager!.name) company")
                    .foregroundColor(.cBlack)
                    .font(Font.custom("Avenir-Light", size: 20.0))

                Text("\(viewModel.errrorMessage)")
                    .foregroundColor(.red)
                    .font(Font.custom("Avenir-Light", size: 20))
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 60, alignment: .center)
                Text("Enter you email address")
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

                HStack {
                    Image(systemName: "person.fill")
                    TextField("First Name", text: $viewModel.firstName)
                        .foregroundColor(.cBlack)
                        .textContentType(.givenName)
                        .autocapitalization(.words)
                        .onTapGesture {
                            viewModel.errrorMessage = ""
                        }
                }.underlineTextField()
                    .padding()

                HStack {
                    Image(systemName: "person.fill")
                    TextField("Last name", text: $viewModel.lastName)
                        .foregroundColor(.cBlack)
                        .textContentType(.familyName)
                        .autocapitalization(.words)
                        .onTapGesture {
                            viewModel.errrorMessage = ""
                        }
                }.underlineTextField()
                    .padding()

                HStack {
                    Text("$$")
                    TextField("Hour rate", text: $viewModel.hourRate)
                        .foregroundColor(.cBlack)
                        .autocapitalization(.none)
                        .onTapGesture {
                            viewModel.errrorMessage = ""
                        }
                }.underlineTextField()
                    .padding()
            }
            .padding(EdgeInsets(top: 20, leading: 45, bottom: 10, trailing: 45))
            }
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
        SignUpView(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider()), managerLoader: FirebaseUserLoader()))
    }
}
