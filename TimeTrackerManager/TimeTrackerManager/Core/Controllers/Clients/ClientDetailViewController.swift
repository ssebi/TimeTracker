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
    let logo = UIImage(named: "parhelion_logo_light")
    var clientInvoiceDetail: ClientBillingInfo?
    var invoice: Invoice?
    typealias InvoiceResult = (Result<InvoiceNo, Error>) -> Void

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
        datePicker.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
        clientName.text = client?.name

        loadInvoiceNo { [weak self] result in
            if case let .success(_) = result {
                self?.invoice = Invoice(
                    client: (self?.client?.name ?? "Unamed"),
                    invoiceNumber: "\(self?.invoiceNo!.series)\(self?.invoiceNoTextField.text!.description)",
                    product: "Software development services",
                    quantity: Int(self?.invoiceTotal.text ?? "") ?? 0,
                    unitCost: self?.client?.hourRate ?? 0,
                    invoiceDate: Date().stringToday()
                )
            }
        }

        loadInvoiceTotal()

        clientInvoiceDetail = ClientBillingInfo(
            name: client?.name ?? "Unamed",
            vat: "VAT: \(client?.vat ?? "VAT:")",
            address: "Address: \(client?.address ?? "")",
            country: "Country: \(client?.country ?? "")"
        )
    }

    @objc private func onDateChanged() {
        loadInvoiceTotal()
    }

    @IBAction func shareAction(_ sender: Any) {
        guard let image = logo,
              let clientInvoice = clientInvoiceDetail,
              let invoice = invoice else { return }

        let invoiceRef = InvoiceCreator(
            title: "Invoice",
            image: image,
            clientDetail: clientInvoice
        )
        
        invoiceRef.createInvoice(invoice: invoice)

        let vc = UIActivityViewController(
            activityItems: [invoiceRef],
            applicationActivities: []
        )
        present(vc, animated: true, completion: nil)
    }
    @IBAction private func previewInvoiceButton(_ sender: Any) {
        if invoiceNoTextField.text != nil,
           invoiceNo?.no != nil,
           invoiceNo?.id != nil {
            let invoiceNoTextField: Int = Int(invoiceNoTextField.text ?? "0") ?? 0
            let dbInvoiceNumber: Int = invoiceNo!.no
            let newInvoiceNo = invoiceNoTextField == dbInvoiceNumber ? dbInvoiceNumber + 1 : invoiceNoTextField
            invoiceManager.updateInvoiceNo(newInvoiceNo: newInvoiceNo, docId: invoiceNo!.id) { _ in }
        }
    }

    private func loadInvoiceNo(completion: @escaping InvoiceResult) {
        invoiceManager.getInvoiceNo { [weak self] result in
            if let invoiceNo = try? result.get() {
                self?.invoiceNo = invoiceNo
                self?.invoiceNoTextField.text = "\(invoiceNo.no)"
                self?.invoiceSeriesLabel.text = "\(invoiceNo.series)"
                completion(result)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "previewInvoice",
              let invoiceVC = segue.destination as? InvoicePreviewViewController,
              let image = logo,
              let clientDetail = clientInvoiceDetail,
              let invoice = invoice else { return }

        let pdfCreator = InvoiceCreator(
            title: "Invoice",
            image: image,
            clientDetail: clientDetail
        )

        invoiceVC.documentData = pdfCreator.createInvoice(invoice: invoice)
    }
}
