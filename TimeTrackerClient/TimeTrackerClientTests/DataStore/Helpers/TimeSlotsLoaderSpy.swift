//
//  TimeSlotsLoaderSpy.swift
//  TimeTrackerClientTests
//
//  Created by Bocanu Mihai on 11.11.2021.
//

import Foundation

protocol TimeSlotsLoader {
    func getTimeSlots() -> [String]
}

class TimeSlotsLoaderSpy: TimeSlotsLoader {
    let clients: [String]

    init(clients: [String]){
        self.clients = clients
    }

    func getTimeSlots() -> [String] {
        return ["Timeslot 1", "TimeSlot 2"]
    }
}
