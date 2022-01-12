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
}
