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
    static let invoiceNo = "invoiceNo"
    static let invoice = "invoice"
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

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }

    func stringToday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        return dateFormatter.string(from: Date())
    }
}
