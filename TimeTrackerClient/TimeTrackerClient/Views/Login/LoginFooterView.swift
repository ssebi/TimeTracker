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
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    viewModel.isForgotten = true
                    viewModel.isSignUp = false
                }
            } label: {
                NavigationLink("Forgot password", destination: ForgotPassword(viewModel: viewModel))
            }
            .padding()
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    viewModel.isSignUp = true
                    viewModel.isForgotten = false
                }
            } label: {
                NavigationLink("Create a new account", destination: SignUpView(viewModel: viewModel))
            }
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
