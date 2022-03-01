//
//  ForgotPassword.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 01.03.2022.
//

import SwiftUI
import TimeTrackerAuth

struct ForgotPassword: View {
    @ObservedObject private(set) var viewModel: LoginViewModel

    var body: some View {
        VStack{
//            Text("You will receive a link to reset your password at the provided email address.")
//                .frame(width: UIScreen.main.bounds.width - 95, height: 50, alignment: .center)
            Group{
                Text("Please enter your email address")
                    .foregroundColor(.cBlack)
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
            }
            .padding(EdgeInsets(top: 20, leading: 45, bottom: 10, trailing: 45))
            .frame(height: 50, alignment: .center)
            Spacer()
            Section {
                Button(action: {
                    viewModel.forgotPassword()
                }) {
                    Text("Forgot password")
                        .font(Font.custom("Avenir-Light", size: 25))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(width: UIScreen.main.bounds.width - 95, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(LinearGradient.gradientBackground)
                .cornerRadius(30)
                .padding(EdgeInsets(top: 50, leading: 45, bottom: 30, trailing: 45))
            }
        }
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider())))
    }
}
