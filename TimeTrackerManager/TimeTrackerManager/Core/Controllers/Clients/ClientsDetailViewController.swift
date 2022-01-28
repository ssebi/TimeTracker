//
//  ClientsDetailViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 28.01.2022.
//

import UIKit

class ClientsDetailViewController: UIViewController {


    @IBOutlet var clientNAme: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "previewInvoice" {
        guard let vc = segue.destination as? InvoicePreviewViewController else { return }
        let pdfCreator = PDFCreator()
        vc.documentData = pdfCreator.createInvoice()
      }
    }
}
