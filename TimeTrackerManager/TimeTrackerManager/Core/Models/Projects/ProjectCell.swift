//
//  ProjectCell.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 31.01.2022.
//

import Foundation

struct ProjectCell {
    let name: String
    let client: String

    public init(name: String, client: String){
        self.name = name
        self.client = client
    }
}
