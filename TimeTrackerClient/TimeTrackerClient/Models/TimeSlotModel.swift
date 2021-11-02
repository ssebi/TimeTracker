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
}

struct TimeSlotDetail: Codable {
    var start: Date
    var end: Date
    var description: String
}

class StartEndDate: ObservableObject {
    var start: Date
    var end: Date
    
    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
}


