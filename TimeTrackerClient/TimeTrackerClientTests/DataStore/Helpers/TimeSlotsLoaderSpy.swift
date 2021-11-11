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
	func getTimeSlots(for clients: [String]) -> [String] {
		["Timeslot 1", "TimeSlot 2"]
	}
}
