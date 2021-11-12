//
//  TimeSlotsPublisherSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 12.11.2021.
//

import Foundation

protocol TimeSlotsPublisher {
    func addTimeSlots(timeSlotCount: Int) -> Int
}

class TimeSlotPublisherSpy: TimeSlotsPublisher {
    var timeslot = 0
    func addTimeSlots(timeSlotCount: Int) -> Int {
        timeslot = timeSlotCount
        return timeslot
    }
}
