//
//  DataStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation
import Firebase

class DataStore: ObservableObject {

	private let timeslotsPublisher: TimeSlotsPublisher
	private let userLoader: UserLoader

	init(
		timeslotsPublisher: TimeSlotsPublisher = RemoteTimeSlotsPublisher(store: FirebaseTimeslotsStore()),
		userLoader: UserLoader = FirebaseUserLoader()
	) {
		self.timeslotsPublisher = timeslotsPublisher
		self.userLoader = userLoader
	}

    func addTimeSlot(timeSlot: TimeSlot, completion: @escaping (Error?) -> Void) {
        timeslotsPublisher.addTimeSlot(timeSlot, completion: completion)
	}

	func getUser() -> User {
		userLoader.getUser()
	}
}
