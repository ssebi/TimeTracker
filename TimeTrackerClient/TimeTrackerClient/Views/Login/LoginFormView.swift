//
//  LoginFormView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.12.2021.
//

import SwiftUI

struct LoginFormView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel
    @State private var isSecured: Bool = true
	
    var body: some View {
        VStack{
            VStack{
                Text("Login with your")
                HStack{
                    Group{Text("TIME") + Text("TRACKER").bold()}
                    Text("account")
                }
            }
            .foregroundColor(Color.cBlack)
            .font(Font.custom("Avenir-Light", size: 20.0))
            Text("\(viewModel.errrorMessage)")
                .foregroundColor(.red)
                .font(Font.custom("Avenir-Light", size: 20))
                .padding()
                .frame(width: UIScreen.main.bounds.width - 60, alignment: .center)
            Group {
                HStack {
                    Image(systemName: "person.fill")
                    CustomTextField(
                        "E-mail",
                        text: self.$viewModel.username,
                        keyboardType: .emailAddress,
                        tag: 1,
                        isSecure: false,
                        returnKeyType: .next,
                        onCommit: {}
                    )
                        .foregroundColor(.cBlack)
                        .textContentType(.emailAddress)
                        .onTapGesture {
                            viewModel.errrorMessage = ""
                        }
                }.underlineTextField()
                HStack {
                    Image(systemName: "lock.fill")

                    ZStack(alignment: .trailing) {
                        if isSecured {
                            CustomTextField(
                                "Password",
                                text: self.$viewModel.password,
                                keyboardType: .default, tag: 2,
                                isSecure: true,
                                returnKeyType: .send,
                                onCommit: {
                                    viewModel.signIn()
                                })
                                .foregroundColor(.cBlack)
                                .textContentType(.password)
                                .onTapGesture {
                                    viewModel.errrorMessage = ""
                                }
                        } else {
                            CustomTextField(
                                "Password",
                                text: self.$viewModel.password,
                                keyboardType: .default,
                                tag: 2, isSecure: false,
                                returnKeyType: .send,
                                onCommit: {
                                    viewModel.signIn()
                                })
                                .foregroundColor(.cBlack)
                                .textContentType(.password)
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
            }
            .padding(EdgeInsets(top: 10, leading: 45, bottom: 10, trailing: 45))
            .frame(height: 50, alignment: .center)

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
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 2) - 10, alignment: .center)
    }
}

struct LoginFormView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider())))
    }
}
