//
//  ClientDetail.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 07.02.2022.
//

import Foundation

struct ClientDetail {
    var name: String
    var vatNo: String
    var address: String
    var country: String

    init(name: String, vatNo: String, address: String, country: String) {
        self.name = name
        self.vatNo = vatNo
        self.address = address
        self.country = country
    }
}
