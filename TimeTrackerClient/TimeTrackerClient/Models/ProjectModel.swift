//
//  ProjectModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation

struct Project {
    var id:  UUID
    var name: String
    var workLog: WorkLog
    var totalWork: Int
}
