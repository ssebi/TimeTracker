//
//  ClientsDetailViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 28.01.2022.
//

import UIKit
import TimeTrackerCore

final class ClientDetailViewController: UIViewController {
    var clientDetail: Client?

    @IBOutlet weak var clientName: UILabel!
    @IBOutlet var invoiceTotal: UILabel!

    init(clientDetail: Client?) {
        self.clientDetail = clientDetail
        super.init(nibName: nil, bundle: nil)
        getClientDetail()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // show bill only for the last month
        clientName.text = clientDetail?.name
        invoiceTotal.text = "350"
    }

    @IBAction func previewInvoiceButton(_ sender: Any) {

    }
    func getClientDetail() {
        if let client = clientDetail {
            //
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
			invoiceNumber: "TMTRK001",
			product: "Programing hours"
		)

		let bodyText = "<<<<<<<< >>>>>  Body Text <<<<< this is a very long text , a text very long tesxt >>>>>"
		guard segue.identifier == "previewInvoice",
			  let invoiceVC = segue.destination as? InvoicePreviewViewController,
			  let image = UIImage(named: "parhelion_logo_light") else { return }

		let pdfCreator = InvoiceCreator(
			title: "Invoice",
			body: bodyText,
			image: image,
			contactInfo: "contact info info",
			clientDetail: clientInvoiceDetail
		)

		invoiceVC.documentData = pdfCreator.createInvoice(invoice: invoice)
	}
}
