//
//  TimeSlot.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation

struct TimeSlot: Identifiable, Codable {
    var id: String?
    var timesSlots: TimeSlotDetail?
    var total: String
    
    init(id: String, timeSlots: TimeSlotDetail, total: String) {
        self.timesSlots = timeSlots
        self.total = total
    }
}

struct TimeSlotDetail: Codable {
    var end: String
    var start: String
    var description: String
}
