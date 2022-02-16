//
//  Invoice.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 04.02.2022.
//

import Foundation
import TimeTrackerCore

struct Invoice {
    var client: String
    var invoiceNumber: String
    var product: String
    var quantity: Int
    var unitCost: Int
    var invoiceDate: String
}

struct InvoiceNo {
    var id: String
    var no: Int
    var series: String
}
