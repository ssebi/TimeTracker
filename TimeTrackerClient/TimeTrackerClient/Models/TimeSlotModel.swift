//
//  TimeSlot.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation
import FirebaseFirestoreSwift

public struct TimeSlot: Identifiable, Decodable {
    @DocumentID public var id: String?
    var userId: String
    var clientId: Int
    var projectId: Int
    var date: Date
    var timeSlotDetail: TimeSlotDetail
    var total: Int

    init(id: String, userId: String, clientId: Int, projectId: Int, date: Date, timeSlotDetail: TimeSlotDetail, total: Int){
        self.id = id
        self.userId = userId
        self.clientId = clientId
        self.projectId = projectId
        self.date = date
        self.timeSlotDetail = timeSlotDetail
        self.total = total
    }
}

extension TimeSlot: Equatable {
    public static func == (lhs: TimeSlot, rhs: TimeSlot) -> Bool {
        lhs.id == rhs.id &&
        lhs.userId == rhs.userId &&
        lhs.clientId == rhs.clientId &&
        lhs.projectId == rhs.projectId &&
        lhs.date == rhs.date &&
        lhs.timeSlotDetail == rhs.timeSlotDetail &&
        lhs.total == rhs.total 
    }
}

public struct TimeSlotDetail: Codable {
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
    public static func == (lhs: TimeSlotDetail, rhs: TimeSlotDetail) -> Bool {
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


