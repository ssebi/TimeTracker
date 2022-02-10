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
    }

    @IBAction func previewInvoiceButton(_ sender: Any) {

    }
    func getClientDetail() {
        if let client = clientDetail {
            print("client name xxX >>>>>", client.name)
        }
    }
    // do this on button press
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let clientInvoiceDetail = ClientDetail(
			name: (clientDetail?.name ?? "No name"),
			vatNo: "xxx2234",
			address: "xxcc adress",
			country: "Romania"
		)
		let invoice = Invoice(
			client: (clientDetail?.name ?? "XX"),
			invoiceNumber: "TMTRK001",
			product: "Programing hours"
		)

		let title = "Invoice"
		let bodyText = "<<<<<<<< >>>>>  Body Text <<<<< this is a very long text , a text very long tesxt >>>>>"
		guard segue.identifier == "previewInvoice",
			  let invoiceVC = segue.destination as? InvoicePreviewViewController,
			  let image = UIImage(named: "parhelion_logo_light") else { return }

		let pdfCreator = InvoiceCreator(
			title: title,
			body: bodyText,
			image: image,
			contactInfo: "contact info info",
			clientDetail: clientInvoiceDetail
		)
		invoiceVC.documentData = pdfCreator.createInvoice(invoice: invoice)
	}
}
