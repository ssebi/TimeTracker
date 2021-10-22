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
    
    init(id:UUID, name: String, projects: Project, totalWork: Int) {
        self.id = id
        self.name = name
        self.projects = projects
        self.totalWork = totalWork
    }
}
