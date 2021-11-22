//
//  TimeSlotsLoaderSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 11.11.2021.
//

import Foundation
import TimeTrackerClient

class TimeSlotsLoaderSpy: TimeSlotsLoader {
	private(set) var getTimeSlotsCalls = 0
	private(set) var userId: String?

	private var getTimeSlotsResult: TimeSlotsLoader.Result?

	func getTimeSlots(for user: String, with client: Int, and project: Int, completion: @escaping TimeSlotsLoader.Result) {
		getTimeSlotsCalls += 1
		userId = user
		getTimeSlotsResult = completion
	}

	func completeGetTimeslots(with error: Error) {
		getTimeSlotsResult?(.failure(error))
	}

	func completeGetTimeslots(with timeslots: [TimeSlot]) {
		getTimeSlotsResult?(.success(timeslots))
	}
}
