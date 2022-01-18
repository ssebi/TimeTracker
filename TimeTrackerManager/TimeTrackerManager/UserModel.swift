//
//  UserModel.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 20.12.2021.
//

import Foundation
import UIKit
import TimeTrackerCore

struct UserCell {
    var name: String
    var userId: String
    var profilePicture: String
    var totalHours: Int?
    var projects: String?
    var hourRate: String?
}

class User {
    var email: String
    var firstName: String
    var lastName: String
    var userId: String
    var userDetails: UserCell

    init(email: String, firstName: String, lastName: String, userId: String, userDetails: UserCell) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.userId = userId
        self.userDetails = userDetails
    }
}
