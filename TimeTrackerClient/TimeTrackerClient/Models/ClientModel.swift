//
//  Client.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation

struct Client {
    var id: UUID
    var name: String
    var projects: Project
    var totalWork: Int
}
