//
//  PdfCreator.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 28.01.2022.
//

import PDFKit

final class PDFCreator {
    func createInvoice(invoice: Invoice) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Invoice",
            kCGPDFContextAuthor: "TimeTracker Manager"
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { context in
            context.beginPage()
            let attributes = [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 41)
            ]
            let title = "Invoice"
            title.draw(at: CGPoint(x: 10, y: 0), withAttributes: attributes)
            invoice.client.draw(at: CGPoint(x: 10, y: 50), withAttributes: attributes)
            invoice.invoiceNumber.draw(at: CGPoint(x: 10, y: 100), withAttributes: attributes)
            invoice.product.draw(at: CGPoint(x: 10, y: 140), withAttributes: attributes)
        }
        return data
    }
}
