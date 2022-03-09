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
    @State var shouldNavigate = false
    @State var showAlert = false
    
    var body: some View {
        VStack{
            Group{
                VStack{
                    Text("Forgot your password? ")
                    Text("Enter your email to reset it.")
                }
                .foregroundColor(Color.cBlack)
                .font(Font.custom("Avenir-Light", size: 20.0))
                .padding(.top, 50).padding(.bottom, 20)
                Spacer()
                Text("\(viewModel.errrorMessage)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                    .font(Font.custom("Avenir-Light", size: 20))
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 60, height: 100, alignment: .center)
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
            }
            .padding(EdgeInsets(top: 20, leading: 45, bottom: 10, trailing: 45))
            .frame(height: 50, alignment: .center)
            Spacer()
                VStack {
                    NavigationLink(destination:  LoginView(viewModel: viewModel), isActive: $shouldNavigate, label: { EmptyView() })
                    Button(action: {
                        viewModel.forgotPassword() { result in
                            guard case .success(_) = result else {
                                return
                            }
                            showAlert = true
                        }
                    }) {
                        Text("Forgot password")
                            .font(Font.custom("Avenir-Light", size: 25))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }.buttonStyle(SubmitButton())
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Email sent"),
                                  message: Text("You can change your password from the link in the email received."),
                                  dismissButton: .default(
                                    Text("Ok, got it"),
                                    action: {
                                        shouldNavigate = true
                                    }
                                  ))
                }
            }
        }
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider())))
    }
}
