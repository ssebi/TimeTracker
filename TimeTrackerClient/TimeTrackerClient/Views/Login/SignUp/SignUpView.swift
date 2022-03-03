//
//  SignUp.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.03.2022.
//

import SwiftUI
import TimeTrackerAuth

struct SignUpView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            TextField("email", text: $viewModel.username)
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider())))
    }
}
