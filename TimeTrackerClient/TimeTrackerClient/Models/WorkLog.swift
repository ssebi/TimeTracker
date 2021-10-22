//
//  WorkLog.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation

struct WorkLog {
    var id: UUID
    var timeSlots: TimeSlot
    var date: Date
    var total: Int
    
    init(id:UUID, timeSlots: TimeSlot, date: Date, total: Int) {
        self.id = id
        self.timeSlots = timeSlots
        self.date = date
        self.total = total
    }
}
