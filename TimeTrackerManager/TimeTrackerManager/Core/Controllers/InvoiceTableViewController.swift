//
//  InvoiceTableTableViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 22.02.2022.
//

import UIKit

class InvoiceTableViewController: UITableViewController {

    private var invoices: [Invoice] = [] {
        didSet { tableView.reloadData() }
    }
    typealias CompletionHandler = (_ success: Bool) -> Void
    private let invoiceManager = FirebaseInvoiceManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInvoicesData {_ in}
    }

    private func loadInvoicesData(completion: @escaping CompletionHandler) {
        invoiceManager.getInvoices { [weak self] result in
            if let invoices = try? result.get() {
                self?.invoices = invoices
                completion(true)
            }
        }
    }
}

extension InvoiceTableViewController {
    private static let invoiceCellIdentifier = "InvoiceListCell"

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.invoiceCellIdentifier, for: indexPath) as? InvoiceListCell else {
            fatalError("Unable to deque cell")
        }

        cell.pdfIcon.image = UIImage(named: "pdfIcon")
        cell.pdfTitle.text = invoices[indexPath.row].title
        return cell
    }
}
