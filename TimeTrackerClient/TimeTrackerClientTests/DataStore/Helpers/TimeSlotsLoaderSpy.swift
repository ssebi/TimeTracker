//
//  TimeSlotsLoaderSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 11.11.2021.
//

import Foundation

protocol TimeSlotsLoader {
	func getTimeSlots(for clients: [String]) -> [String]
}

class TimeSlotsLoaderSpy: TimeSlotsLoader {
	private(set) var getTimeSlotsCalls = 0

	private var getTimeSlotsResult: [String] = []

	func getTimeSlots(for clients: [String]) -> [String] {
		getTimeSlotsCalls += 1
		return getTimeSlotsResult
	}

	func completeGetTimeslots(with timeslots: [String]) {
		getTimeSlotsResult = timeslots
	}
}
