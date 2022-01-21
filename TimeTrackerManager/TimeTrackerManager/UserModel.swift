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
    let name: String
    let userId: String
    let profilePicture: String
    let totalHours: Int?
    let projects: String?
    let hourRate: String?
    let documentId: String
}

extension UserCell {
	var profilePictureURLOrDefault: URL {
		URL(string: profilePicture) ?? Constants.defaultProfileImageURL
	}
}
