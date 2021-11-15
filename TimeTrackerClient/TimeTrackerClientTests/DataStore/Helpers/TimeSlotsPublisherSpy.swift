//
//  TimeSlotsPublisherSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 12.11.2021.
//

import Foundation
@testable import TimeTrackerClient

protocol TimeSlotsPublisher {
    func addTimeSlots(timeSlot: TimeSlot) -> TimeSlot
}

class TimeSlotPublisherSpy: TimeSlotsPublisher {
    var timeslot = 0

    func addTimeSlots(timeSlot: TimeSlot) -> TimeSlot {
        timeslot += 1
        return timeSlot
    }
}
