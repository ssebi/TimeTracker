//
//  ClientsDetailViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 28.01.2022.
//

import UIKit

final class ClientDetailViewController: UIViewController {

    @IBOutlet private var clientNAme: UITextView!
    var invoice = Invoice(client: "Client Name", invoiceNumber: "TMTRK001", product: "Programing hours")

    override func viewDidLoad() {
        super.viewDidLoad()
//        if !clientDetail.isEmpty {
//            clientNAme.text = clientDetail
//        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "previewInvoice" {
        guard let invoiceVC = segue.destination as? InvoicePreviewViewController else { return }
        let pdfCreator = PDFCreator()
          invoiceVC.documentData = pdfCreator.createInvoice(invoice: invoice)
      }
    }
}
