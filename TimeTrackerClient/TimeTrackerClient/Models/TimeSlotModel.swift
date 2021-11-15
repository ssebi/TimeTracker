//
//  TimeSlot.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation
import FirebaseFirestoreSwift

struct TimeSlot: Identifiable, Decodable {
    @DocumentID var id: String?
    var timeSlots: TimeSlotDetail
    var total: Int

    init(id: String, timeSlots: TimeSlotDetail, total: Int){
        self.id = id
        self.timeSlots = timeSlots
        self.total = total
    }
}

extension TimeSlot: Equatable {
    static func == (lhs: TimeSlot, rhs: TimeSlot) -> Bool {
        lhs.id == rhs.id &&
        lhs.timeSlots == rhs.timeSlots &&
        lhs.total == rhs.total 
    }
}

struct TimeSlotDetail: Codable {
    var start: Date
    var end: Date
    var description: String

    init(start: Date, end: Date, description: String){
        self.start = start
        self.end = end
        self.description = description
    }
}

extension TimeSlotDetail: Equatable {
    static func == (lhs: TimeSlotDetail, rhs: TimeSlotDetail) -> Bool {
        lhs.start == rhs.start &&
        lhs.end == rhs.end &&
        lhs.description == rhs.description
    }
}

class StartEndDate: ObservableObject {
    var start: Date
    var end: Date
    
    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
}


