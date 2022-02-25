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
    var invoice: InvoiceDetails?
    typealias InvoiceResult = (Result<InvoiceNo, Error>) -> Void

    @IBOutlet weak var clientName: UILabel!
    @IBOutlet private var invoiceTotal: UILabel!
    @IBOutlet private var invoiceNoTextField: UITextField!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var invoiceSeriesLabel: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

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
                self?.invoice = InvoiceDetails(
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

        let invoiceData = invoiceRef.createInvoice(invoice: invoice)
        let vc = UIActivityViewController(
            activityItems: [invoiceData],
            applicationActivities: []
        )
        present(vc, animated: true, completion: nil)
    }

    @IBAction private func previewInvoiceButton(_ sender: Any) {
        // preview button pressed

    }

    @IBAction func saveInvoiceButton(_ sender: Any) {
        toggleSpiner(isHidden: false)
        if invoiceNoTextField.text != nil,
           invoiceNo?.no != nil,
           invoiceNo?.id != nil {
            let invoiceNoTextField: Int = Int(invoiceNoTextField.text ?? "0") ?? 0
            let dbInvoiceNumber: Int = invoiceNo!.no
            let newInvoiceNo = invoiceNoTextField == dbInvoiceNumber ? dbInvoiceNumber + 1 : invoiceNoTextField

            guard let image = logo,
                  let clientInvoice = clientInvoiceDetail,
                  let invoice = invoice else { return }

            let invoiceRef = InvoiceCreator(
                title: "Invoice",
                image: image,
                clientDetail: clientInvoice
            )

           let invoiceData = invoiceRef.createInvoice(invoice: invoice)
            let name = client?.name ?? "Invoice "
            let date = datePicker.date.stringToday()

            invoiceManager.updateInvoiceNo(newInvoiceNo: newInvoiceNo, docId: invoiceNo!.id) { _ in }
            invoiceManager.saveInvoice(title: "\(name)-\(newInvoiceNo)-\(date)", data: invoiceData.base64EncodedString()) { [weak self] result in
                switch result {
                case .success:
                    self?.validationError(title: "Success", message: "Invoice saved", hasError: false)
                case .failure(let error):
                    self?.validationError(title: "Error", message: "Invoice save failed: \(error)", hasError: true)
                }
            }
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
              let invoiceVC = segue.destination as? InvoicePreviewPDFViewVC,
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

    func convertToBase64(pdf: Data) -> String {
        var invoiceData: Data?
        invoiceData = pdf.base64EncodedData()
        return invoiceData?.base64EncodedString() ?? ""
    }

    private func toggleSpiner(isHidden: Bool) {
        activityIndicator.isHidden = isHidden
        if isHidden == true {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }

    private func validationError(title: String, message: String, hasError: Bool) {
        self.toggleSpiner(isHidden: true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            if !hasError { self.dismisView() }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func dismisView() {
        self.navigationController?.popViewController(animated: true)
    }
}
