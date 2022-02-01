//
//  ClientsDetailViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 28.01.2022.
//

import UIKit

final class ClientsDetailViewController: UIViewController {
    @IBOutlet private var clientNAme: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "previewInvoice" {
        guard let invoiceVC = segue.destination as? InvoicePreviewViewController else { return }
        let pdfCreator = PDFCreator()
          invoiceVC.documentData = pdfCreator.createInvoice()
      }
    }
}
