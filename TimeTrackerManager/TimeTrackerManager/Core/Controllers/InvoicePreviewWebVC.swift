//
//  InvoicePreviewWebVC.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 25.02.2022.
//

import UIKit
import WebKit

class InvoicePreviewWebVC: UIViewController {

    @IBOutlet var webKitView: WKWebView!
    public var documentData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = documentData {
            webKitView.load(data, mimeType: "application/pdf",
                            characterEncodingName: "utf-8",
                            baseURL: URL(fileURLWithPath: ""))
        }
    }

    @IBAction func shareButton(_ sender: Any) {
        guard let data = documentData else { return }
        let avc = UIActivityViewController(
            activityItems: [data],
            applicationActivities: []
        )
		avc.popoverPresentationController?.sourceView = view
        present(avc, animated: true, completion: nil)
    }
}
