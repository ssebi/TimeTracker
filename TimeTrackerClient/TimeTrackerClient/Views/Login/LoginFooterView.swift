//
//  LoginFooterView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.12.2021.
//

import SwiftUI
import TimeTrackerAuth
import TimeTrackerCore

struct LoginFooterView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel
    @State var showAlert = false

    var body: some View {
        VStack {
            Spacer()
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    viewModel.isSignUp = true
                    viewModel.isForgotten = false
                }
            } label: {
                NavigationLink("Create a new account", destination: AssociateView(viewModel: viewModel))
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    viewModel.isForgotten = true
                    viewModel.isSignUp = false
                }
            } label: {
                NavigationLink("Forgot password", destination: ForgotPassword(viewModel: viewModel))
            }
            .padding(.bottom, 50)
        }
        .padding()
        .foregroundColor(.cGray)
    }
}

struct LoginFooterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFooterView(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider()), managerLoader: FirebaseUserLoader()))
    }
}
