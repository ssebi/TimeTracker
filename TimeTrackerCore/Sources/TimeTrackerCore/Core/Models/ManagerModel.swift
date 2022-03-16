//
//  File.swift
//  
//
//  Created by Bocanu Mihai on 09.03.2022.
//

import Foundation

public struct Manager {
    public let id: String
    public let email: String
    public let name: String

    public init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }

}
