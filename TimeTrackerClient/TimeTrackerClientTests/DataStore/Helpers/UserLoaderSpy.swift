//
//  UserLoaderSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 12.11.2021.
//

import Foundation
@testable import TimeTrackerClient

protocol UserLoader {
    func getUser() -> User
}

class UserLoaderSpy: UserLoader {
    private var userId: String = ""
    private var user: User = User(uid: "xxxxxxxxx", email: "test@test.com", username: "Test", client: "Client 2")

    func getUser() -> User {
        return user
    }
}
