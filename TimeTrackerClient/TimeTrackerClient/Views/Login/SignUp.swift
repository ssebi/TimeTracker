//
//  SignUp.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.03.2022.
//

import SwiftUI
import TimeTrackerAuth

struct SignUp: View {
    @ObservedObject private(set) var viewModel: LoginViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider())))
    }
}
