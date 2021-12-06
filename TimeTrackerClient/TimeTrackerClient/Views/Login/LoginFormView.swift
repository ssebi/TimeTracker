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
    @State var focused: [Bool] = [true, false]

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

            Group {
                Text("\(viewModel.errrorMessage)")
                    .foregroundColor(.red)
                    .font(Font.custom("Avenir-Light", size: 20))
                    .padding()

                HStack {
                    Image(systemName: "person.fill")
                    CustomTextField(
                        text: $viewModel.username,
                        isSecured: false,
                        keyboard: .default,
                        returnKeyType: UIReturnKeyType.next,
                        placeholder: "E-mail",
                        onSubmit: { }, tag: 0 )
                            .tag(0)
                            .cornerRadius(10)
                            .foregroundColor(.cBlack)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .frame(height: 30, alignment: .center)
                            .textContentType(.some(.emailAddress))
                            .keyboardType(.emailAddress)
                            .onTapGesture {
                                viewModel.errrorMessage = ""
                            }
                }
                .underlineTextField()
                .frame(height: 50, alignment: .center)

                HStack {
                    Image(systemName: "lock.fill")

                    ZStack(alignment: .trailing) {
                        CustomTextField(
                            text: $viewModel.password,
                            isSecured: isSecured,
                            keyboard: .default,
                            returnKeyType: UIReturnKeyType.done,
                            placeholder: "Password",
                            onSubmit: { viewModel.signIn()}, tag: 1)
                                .tag(1)
                                .foregroundColor(.cBlack)
                                .cornerRadius(10)
                                .frame(height: 30, alignment: .center)
                                .textContentType(.some(.password))
                                .onTapGesture {
                                    viewModel.errrorMessage = ""
                                }
                        Button(action: {
                            isSecured.toggle()
                        }) {
                            Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                .accentColor(.cGray)
                        }
                    }
                }
                .underlineTextField()
                .frame(height: 50, alignment: .center)
            }
            .padding(EdgeInsets(top: 10, leading: 45, bottom: 10, trailing: 45))

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
