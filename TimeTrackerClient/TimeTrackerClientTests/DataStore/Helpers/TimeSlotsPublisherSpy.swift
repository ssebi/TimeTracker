//
//  TimeSlotsPublisherSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 12.11.2021.
//

import Foundation
import TimeTrackerClient

class TimeSlotPublisherSpy: TimeSlotsPublisher {
    private(set) var timeslotCalls = 0

	private var addTimeSlotResult: TimeSlotsPublisher.Result?

	func addTimeSlots(timeSlot: TimeSlot, completion: @escaping TimeSlotsPublisher.Result) {
        timeslotCalls += 1
		addTimeSlotResult = completion
    }

	func completeAddTimeSlots(with error: Error) {
		addTimeSlotResult?(.failure(error))
	}

	func completeAddTimeSlots(with timeSlot: TimeSlot) {
		addTimeSlotResult?(.success(timeSlot))
	}
}
