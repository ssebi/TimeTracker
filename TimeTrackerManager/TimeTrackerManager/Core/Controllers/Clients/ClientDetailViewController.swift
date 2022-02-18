//
//  ClientsDetailViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 28.01.2022.
//

import UIKit
import TimeTrackerCore
import SwiftUI

final class ClientDetailViewController: UIViewController {
    var client: Client?
    private var invoiceManager = FirebaseInvoiceManager()
    private var invoiceNo: InvoiceNo?
    private let dateFormatter = DateFormatter()

    @IBOutlet weak var clientName: UILabel!
    @IBOutlet private var invoiceTotal: UILabel!
    @IBOutlet private var invoiceNoTextField: UITextField!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var invoiceSeriesLabel: UITextView!

    init(client: Client?) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.datePickerMode = UIDatePicker.Mode.date
        clientName.text = client?.name
        loadInvoiceNo()
        loadInvoiceTotal()
    }

    @IBAction private func previewInvoiceButton(_ sender: Any) {
        loadInvoiceTotal()
        if invoiceNoTextField.text != nil,
           invoiceNo?.no != nil,
           invoiceNo?.id != nil {
            let invoiceNoTextField: Int = Int(invoiceNoTextField.text ?? "0") ?? 0
            let dbInvoiceNumber: Int = invoiceNo!.no
            let newInvoiceNo = invoiceNoTextField == dbInvoiceNumber ? dbInvoiceNumber + 1 : invoiceNoTextField
            invoiceManager.updateInvoiceNo(newInvoiceNo: newInvoiceNo, docId: invoiceNo!.id) { _ in }
        }
    }

    private func loadInvoiceNo() {
        invoiceManager.getInvoiceNo { [weak self] result in
            if let invoiceNo = try? result.get() {
                self?.invoiceNo = invoiceNo
                self?.invoiceNoTextField.text = "\(invoiceNo.no)"
                self?.invoiceSeriesLabel.text = "\(invoiceNo.series)"
            }
        }
    }

    private func loadInvoiceTotal() {
        if let clientName = client?.name {
            invoiceManager.getInvoiceTotal(clientName: clientName, date: datePicker.date) { [weak self] result in
                if case let .success(total) = result {
                    self?.invoiceTotal.text = "\(total)"
                }
            }
        }
    }

    // do this on button press
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		let clientInvoiceDetail = ClientBillingInfo(
            name: client?.name ?? "Unamed",
            vat: "VAT: \(client?.vat ?? "VAT:")",
            address: "Address: \(client?.address ?? "")",
            country: "Country: \(client?.country ?? "")"
		)

		let invoice = Invoice(
			client: (client?.name ?? "Unamed"),
            invoiceNumber: "\(invoiceNo!.series)\(invoiceNoTextField.text!.description)",
			product: "Software development services",
            quantity: Int(invoiceTotal.text ?? "") ?? 0,
            unitCost: client?.hourRate ?? 0,
            invoiceDate: Date().stringToday()
		)

		guard segue.identifier == "previewInvoice",
			  let invoiceVC = segue.destination as? InvoicePreviewViewController,
			  let image = UIImage(named: "parhelion_logo_light") else { return }

		let pdfCreator = InvoiceCreator(
			title: "Invoice",
			image: image,
			clientDetail: clientInvoiceDetail
		)

		invoiceVC.documentData = pdfCreator.createInvoice(invoice: invoice)
	}
}
