//
//  Client.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation

public struct Client: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let projects: [Project]
    public let vat: String
    public let address: String
    public let country: String
    public let hourRate: Int

    public init(id: String, name: String, projects: [Project], vat: String, address: String, country: String, hourRate: Int) {
		self.id = id
		self.name = name
		self.projects = projects
        self.vat = vat
        self.address = address
        self.country = country
        self.hourRate = hourRate
	}
}
