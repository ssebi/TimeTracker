//
//  TimeSlot.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation

public struct TimeSlot: Identifiable, Codable {
    public var id: String?
    var userId: String
    var clientId: Int
    var projectId: Int
    var date: String
    var details: TimeSlotDetails
    var total: Int

    public init(id: String, userId: String, clientId: Int, projectId: Int, date: String, details: TimeSlotDetails, total: Int) {
        self.id = id
        self.userId = userId
        self.clientId = clientId
        self.projectId = projectId
        self.date = date
        self.details = details
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
        lhs.details == rhs.details &&
        lhs.total == rhs.total 
    }
}

public struct TimeSlotDetails: Codable {
    var start: String
    var end: String
    var description: String

    public init(start: String, end: String, description: String) {
        self.start = start
        self.end = end
        self.description = description
    }
}

extension TimeSlotDetails: Equatable {
    public static func == (lhs: TimeSlotDetails, rhs: TimeSlotDetails) -> Bool {
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


