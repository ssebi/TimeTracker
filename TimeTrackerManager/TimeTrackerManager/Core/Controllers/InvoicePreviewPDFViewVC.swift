//
//  InvoicePreviewViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 28.01.2022.
//

import UIKit
import PDFKit

final class InvoicePreviewPDFViewVC: UIViewController {
    @IBOutlet weak var pdfView: PDFView!
    public var documentData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
        }
    }

	@IBAction func shareAction(_ sender: Any) {
		guard let invoiceData = documentData else {
			return
		}
		let avc = UIActivityViewController(
			activityItems: [invoiceData],
			applicationActivities: []
		)
		avc.popoverPresentationController?.sourceView = view
		present(avc, animated: true, completion: nil)
	}
}
