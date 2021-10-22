//
//  TimeSlot.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation

struct TimeSlot {
    var id: UUID
    var start: Date
    var end: Date
    var description: String
    
    init(id: UUID, start: Date, end: Date, description: String) {
        self.id = id
        self.start = start
        self.end = end
        self.description = description
    }
}
