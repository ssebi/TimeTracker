//
//  ClientDetail.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 07.02.2022.
//

import Foundation

struct ClientBillingInfo {
    var name: String
    var vat: String
    var address: String
    var country: String

    init(name: String, vat: String, address: String, country: String) {
        self.name = name
        self.vat = vat
        self.address = address
        self.country = country
    }
}
