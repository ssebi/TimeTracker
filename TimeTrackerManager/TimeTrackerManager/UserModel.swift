//
//  UserModel.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 20.12.2021.
//

import Foundation
import UIKit

struct User {
    let name: String
    let profilePicture: UIImage?
    let totalHours: Int
    let projects: [String]
    let hourRate: Int
}

extension User {
    static var testData = [
        User(name: "User 1", profilePicture: UIImage(contentsOfFile: ""), totalHours: 20, projects: ["Project x, Porject Y"], hourRate: 20),
        User(name: "User 2", profilePicture: UIImage(contentsOfFile: ""), totalHours: 11, projects: ["Project 1"], hourRate: 22),
        User(name: "User 3",  profilePicture: UIImage(contentsOfFile: ""), totalHours: 30, projects: ["PROJECT XXX"], hourRate: 50),
        User(name: "user 5", profilePicture: UIImage(contentsOfFile: ""), totalHours: 120, projects: ["Project second", "Secodn Project" ], hourRate: 120)
    ]

}
