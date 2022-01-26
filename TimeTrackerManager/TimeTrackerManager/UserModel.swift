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
	let documentId: String
    let hourRate: String?

	let timeSlots: ((String, @escaping TimeslotsStore.GetTimeslotsResult) -> Void)?
}

extension UserCell {
	var profilePictureURLOrDefault: URL {
		URL(string: profilePicture) ?? Constants.defaultProfileImageURL
	}
}
