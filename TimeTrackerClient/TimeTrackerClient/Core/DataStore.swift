//
//  DataStore.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation
import Firebase

class DataStore: ObservableObject {
	@Published var userTimeslots = [TimeSlot]()

    let db = Firestore.firestore()


	private let clientLoader: ClientsLoader
	private let timeslotsPublisher: TimeSlotsPublisher
	private let userLoader: UserLoader

	init(
		clientLoader: ClientsLoader = FirebaseClientsLoader(),
		timeslotsPublisher: TimeSlotsPublisher = FirebaseTimeslotsPublisher(),
		userLoader: UserLoader = FirebaseUserLoader()
	) {
		self.clientLoader = clientLoader
		self.timeslotsPublisher = timeslotsPublisher
		self.userLoader = userLoader
	}

    func addTimeSlot(timeSlot: TimeSlot, to path: String, completion: @escaping TimeSlotsPublisher.Result) {
        timeslotsPublisher.addTimeSlots(timeSlot: timeSlot, to: path, completion: completion)
	}

	func getUser() -> User {
		userLoader.getUser()
	}
}
