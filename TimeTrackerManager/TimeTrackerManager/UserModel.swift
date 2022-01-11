//
//  UserModel.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 20.12.2021.
//

import Foundation
import UIKit

struct UserCell {
    let name: String
    let profilePicture: UIImage?
    let totalHours: Int
    let projects: [String]
    let hourRate: Int
}

class User {
    let email: String
    let firstName: String
    let lastName: String

    init(email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension UserCell {
    static var testData = [
        UserCell(name: "User 1", profilePicture: UIImage(contentsOfFile: ""), totalHours: 20, projects: ["Project x, Porject Y"], hourRate: 20),
        UserCell(name: "User 2", profilePicture: UIImage(contentsOfFile: ""), totalHours: 11, projects: ["Project 1"], hourRate: 22),
        UserCell(name: "User 3",  profilePicture: UIImage(contentsOfFile: ""), totalHours: 30, projects: ["PROJECT XXX"], hourRate: 50),
        UserCell(name: "user 5", profilePicture: UIImage(contentsOfFile: ""), totalHours: 120, projects: ["Project second", "Secodn Project" ], hourRate: 120)
    ]
}
