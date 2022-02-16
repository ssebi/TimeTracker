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
    var clientDetail: Client?
    var invoice = FirebaseInvoiceManager()

    typealias CompletionHandler = (_ success: Bool) -> Void
    var invoiceNo: InvoiceNo?

    @IBOutlet weak var clientName: UILabel!
    @IBOutlet var invoiceTotal: UILabel!
    @IBOutlet var invoiceNoTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var invoiceSeriesLabel: UITextView!

    init(clientDetail: Client?) {
        self.clientDetail = clientDetail
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // show bill only for the last month
        clientName.text = clientDetail?.name
        invoiceTotal.text = "350"
        loadInvoiceNo()
    }

    @IBAction func previewInvoiceButton(_ sender: Any) {
        if invoiceNoTextField.text != nil,
           invoiceNo?.no != nil,
           invoiceNo?.id != nil {
            let invoiceNoTextField: Int = Int(invoiceNoTextField.text ?? "0") ?? 0
            let dbInvoiceNumber: Int = invoiceNo!.no
            let newInvoiceNo = invoiceNoTextField == dbInvoiceNumber ? dbInvoiceNumber + 1 : invoiceNoTextField
            invoice.updateInvoiceNo(newInvoiceNo: newInvoiceNo, docId: invoiceNo!.id) { error in
                //show alert if error
            }
        }
    }

    private func loadInvoiceNo() {
        invoice.getInvoiceNo { [weak self] result in
            if let invoiceNo = try? result.get() {
                self?.invoiceNo = invoiceNo
                self?.invoiceNoTextField.text = "\(invoiceNo.no)"
                self?.invoiceSeriesLabel.text = "\(invoiceNo.series)"
            }
        }
    }

    // do this on button press
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		let clientInvoiceDetail = ClientBillingInfo(
            name: clientDetail?.name ?? "Unamed",
            vat: clientDetail?.vat ?? "",
            address: clientDetail?.address ?? "",
            country: clientDetail?.country ?? ""
		)

		let invoice = Invoice(
			client: (clientDetail?.name ?? "Unamed"),
            invoiceNumber: "\(invoiceNo!.series)\(invoiceNoTextField.text!.description)",
			product: "Software development services",
            quantity: 100,
            unitCost: 122,
            invoiceDate: datePicker.date.description
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
