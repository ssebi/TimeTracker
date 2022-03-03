//
//  LoginFooterView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.12.2021.
//

import SwiftUI
import TimeTrackerAuth

struct LoginFooterView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel
    @State var showAlert = false

    var body: some View {
        VStack {
            Spacer()
            if viewModel.isForgotten == false {
            Button(
                action: {
                    viewModel.isForgotten = true
                    viewModel.isSignUp = false
                    viewModel.cardViewHeight = 4
                },
                label: {
                    NavigationLink("Forgot password", destination: ForgotPassword(viewModel: viewModel))
                })
                    .padding()
            } else {

            Button(
                action: {
                    viewModel.isForgotten = false
                    viewModel.isSignUp = false
                    viewModel.cardViewHeight = 2
                },
                label: {
                    NavigationLink("Log In", destination: LoginView(viewModel: viewModel))
                })
            }
            if viewModel.isSignUp == false {
                Button(
                    action: {
                        viewModel.isSignUp = true
                        viewModel.isForgotten = false
                        viewModel.cardViewHeight = 4
                    },
                    label: {
                        NavigationLink("Create a new account", destination: SignUpView(viewModel: viewModel))
                    })
                    .padding()
            } else {

                Button(
                    action: {
                        viewModel.isSignUp = true
                        viewModel.isForgotten = false
                        viewModel.cardViewHeight = 2
                    },
                    label: {
                        NavigationLink("Log In", destination: LoginFormView(viewModel: viewModel))
                    })
                    .padding()
            }
//            Button("Create a new account") {
//                showAlert = true
//                    }
//                    .alert(isPresented: $showAlert) {
//                        Alert(title: Text("Coming soon"), message: Text("This functionality is under development"), dismissButton: .default(Text("Got it!")))
//                    }
        }
        .padding()
        .foregroundColor(.cGray)
    }
}

struct LoginFooterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFooterView(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider())))
    }
}
