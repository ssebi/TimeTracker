//
//  Client.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation

struct Client: Identifiable, Codable, Equatable {
	var id: Int = 0
    var name: String
    var projects: [Project]
}
