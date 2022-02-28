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
	let timeSlots: [TimeSlot]

	init(
		name: String,
		userId: String,
		profilePicture: String,
		documentId: String,
		hourRate: String?,
		timeSlots: [TimeSlot] = []
	) {
		self.name = name
		self.userId = userId
		self.profilePicture = profilePicture
		self.documentId = documentId
		self.hourRate = hourRate
		self.timeSlots = timeSlots
	}

	func addTimeslots(_ timeslots: [TimeSlot]) -> UserCell {
		UserCell(name: name,
				 userId: userId,
				 profilePicture: profilePicture,
				 documentId: documentId,
				 hourRate: hourRate,
				 timeSlots: timeslots)
	}
}

extension UserCell {
	var profilePictureURLOrDefault: URL {
		URL(string: profilePicture) ?? Constants.defaultProfileImageURL
	}
}
