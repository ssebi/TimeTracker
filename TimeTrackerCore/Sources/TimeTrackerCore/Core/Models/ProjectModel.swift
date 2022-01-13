//
//  ProjectModel.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 22.10.2021.
//

import Foundation

public struct Project: Codable, Hashable {
    public init(name: String){
        self.name = name
    }

    public let name: String
}
