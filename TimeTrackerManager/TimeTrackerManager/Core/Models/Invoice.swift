//
//  Invoice.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 04.02.2022.
//

import Foundation

struct InvoiceDetails {
    var client: String
    var invoiceNumber: String
    var product: String
    var quantity: Int
    var unitCost: Int
    var invoiceDate: String
}

struct InvoiceNo {
    var id: String
    var number: Int
    var series: String
}

struct InvoiceTotal {
    var total: Int
    var date: Date
}

struct Invoice: Decodable {
    var title: String
    var date: String
    var data: String
}
