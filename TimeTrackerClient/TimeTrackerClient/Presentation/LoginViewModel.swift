//
//  LoginViewModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 24.11.2021.
//

import Foundation
import SwiftUI
import GameKit

public class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""

    @Published var isLoading = true
    var session: SessionStore

    init(session: SessionStore){
        self.session = session
        isLoading = false
    }

    func signIn() {
        isLoading = true
        print(username)
        session.signIn(email: username, password: password) { [weak self] _ in
            self?.isLoading = false
        }
    }


}
