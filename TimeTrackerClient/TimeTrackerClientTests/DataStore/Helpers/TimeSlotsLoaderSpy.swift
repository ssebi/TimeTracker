//
//  TimeSlotsLoaderSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 11.11.2021.
//

import Foundation
@testable import TimeTrackerClient

protocol TimeSlotsLoader {
	func getTimeSlots(for user: [String]) -> [TimeSlot]
}

class TimeSlotsLoaderSpy: TimeSlotsLoader {
	private(set) var getTimeSlotsCalls = 0
	private(set) var userId: [String]?

	private var getTimeSlotsResult: [TimeSlot] = []

	func getTimeSlots(for userId: [String]) -> [TimeSlot] {
		getTimeSlotsCalls += 1
		self.userId = userId
		return getTimeSlotsResult
	}

	func completeGetTimeslots(with timeslots: [TimeSlot]) {
		getTimeSlotsResult = timeslots
	}
}
