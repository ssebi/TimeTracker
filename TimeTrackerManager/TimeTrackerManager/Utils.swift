//
//  Utils.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 11.01.2022.
//

import Foundation

struct Path {
    static let users = "users"
    static let timeSlots = "timeSlots"
    static let clients = "Clients"
    static let invoieNo = "invoiceNo"
}

struct Constants {
	static let defaultProfileImageURL = URL(string: "https://avatars.dicebear.com/api/bottts/avatar.png")!
}

import TimeTrackerCore

extension TimeslotsStore {
	func getTimeslots(userID: String) async -> [TimeSlot]? {
		await withCheckedContinuation { continuation in
			getTimeslots(userID: userID) { result in
				continuation.resume(returning: try? result.get())
			}
		}
	}
}
