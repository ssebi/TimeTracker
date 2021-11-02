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
    
    //init(id: String, timeSlots: TimeSlotDetail, total: String) {
      //  self.timeSlots = timeSlots
     //   self.total = total
  //  }
}

struct TimeSlotDetail: Codable {
    var end: String
    var start: String
    var description: String
    
    static func ==(lhs: TimeSlotDetail, rhs: TimeSlotDetail) -> Bool {
        return lhs.end == rhs.end && lhs.start == rhs.start && lhs.description == rhs.description
       }
}
