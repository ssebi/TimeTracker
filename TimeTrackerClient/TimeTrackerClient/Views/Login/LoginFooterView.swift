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
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        viewModel.isForgotten = true
                        viewModel.isSignUp = false
                        viewModel.cardViewHeight = 3
                    }
                } label: {
                    NavigationLink("Forgot password", destination: ForgotPassword(viewModel: viewModel))
                }
                .padding()
            } else {

                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        viewModel.isForgotten = false
                        viewModel.isSignUp = false
                        viewModel.cardViewHeight = 2
                    }
                } label: {
                    NavigationLink("Log In", destination: LoginView(viewModel: viewModel))
                }
                .padding()
            }
            if viewModel.isSignUp == false {
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        viewModel.isSignUp = true
                        viewModel.isForgotten = false
                        viewModel.cardViewHeight = 3
                    }
                } label: {
                    NavigationLink("Create a new account", destination: SignUpView(viewModel: viewModel))
                }
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        viewModel.isSignUp = false
                        viewModel.isForgotten = false
                        viewModel.cardViewHeight = 2
                    }
                } label: {
                    NavigationLink("Log In", destination: LoginView(viewModel: viewModel))
                }
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
