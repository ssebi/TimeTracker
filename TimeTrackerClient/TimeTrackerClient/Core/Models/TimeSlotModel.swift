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
    var clientName: String
    var projectName: String
    var date: Date
    var details: TimeSlotDetails
    var total: Int

    public init(id: String, userId: String, clientName: String, projectName: String, date: Date, details: TimeSlotDetails, total: Int) {
        self.id = id
        self.userId = userId
        self.clientName = clientName
        self.projectName = projectName
        self.date = date
        self.details = details
        self.total = total
    }
}

extension TimeSlot: Equatable {
    public static func == (lhs: TimeSlot, rhs: TimeSlot) -> Bool {
        lhs.id == rhs.id &&
        lhs.userId == rhs.userId &&
        lhs.clientName == rhs.clientName &&
        lhs.projectName == rhs.projectName &&
        lhs.date == rhs.date &&
        lhs.details == rhs.details &&
        lhs.total == rhs.total 
    }
}

public struct TimeSlotDetails: Codable {
    var start: Date
    var end: Date
    var description: String

    public init(start: Date, end: Date, description: String) {
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


