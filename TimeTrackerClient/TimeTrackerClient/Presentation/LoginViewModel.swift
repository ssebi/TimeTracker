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
    @Published var showError = true

    @Published var errrorMessage = ""

    @Published var isLoading = true
    var session: SessionStore

    init(session: SessionStore){
        self.session = session
        isLoading = false
    }

    func signIn() {
        isLoading = true
        print(username)
        session.signIn(email: username, password: password) { [weak self] result in
            self?.isLoading = false
            if case let .failure(result) =  result {
                self?.errrorMessage = result.localizedDescription
            }
        }
    }


}
