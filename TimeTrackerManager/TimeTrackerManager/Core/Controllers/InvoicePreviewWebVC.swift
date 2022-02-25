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
            webKitView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: URL(fileURLWithPath: ""))
        }
    }

}
