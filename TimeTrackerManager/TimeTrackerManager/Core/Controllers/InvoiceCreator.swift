//
//  PdfCreator.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 28.01.2022.
//

import PDFKit

final class InvoiceCreator {
    let title: String
    let body: String
    let image: UIImage
    let contactInfo: String
    let clientDetail: ClientDetail

    init(title: String, body: String, image: UIImage, contactInfo: String, clientDetail: ClientDetail) {
        self.title = title
        self.body = body
        self.image = image
        self.contactInfo = contactInfo
        self.clientDetail = clientDetail
    }

    func createInvoice(invoice: Invoice) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Invoice",
            kCGPDFContextAuthor: "TimeTracker Manager",
            kCGPDFContextTitle: title
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { context in
            context.beginPage()
//            let attributes = [
//                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 41)
//            ]

            let logo = addLogo(pageRect: pageRect, imageTop: 40)
            let titleBottom = addTitle(pageRect: pageRect, titleTop: logo + 60.0)
            addCompanyInfo(
                pageRect: pageRect,
                infoTop: 40.0,
                name: "Parhelion",
                address: "Moldovei 3",
                vatNo: "RO4323455"
            )
            let invoiceHeaderBottom = addInvoiceHeader(
                pageRect: pageRect,
                infoTop: titleBottom + 18.0,
                invoiceNo: invoice.invoiceNumber,
                invoiceDate: "20-02-2022",
                clientDetail: clientDetail
            )
            let context = context.cgContext

            drawTableLines(context, pageRect: pageRect, lineTop: titleBottom + 10.0)
            drawTableLines(context, pageRect: pageRect, lineTop: invoiceHeaderBottom + 10.0)
          //  addBodyText(pageRect: pageRect, textTop: logo + 18.0)

//            invoice.client.draw(at: CGPoint(x: 10, y: 50), withAttributes: attributes)
//            invoice.invoiceNumber.draw(at: CGPoint(x: 10, y: 100), withAttributes: attributes)
//            invoice.product.draw(at: CGPoint(x: 10, y: 140), withAttributes: attributes)
        }
        return data
    }

    func addTitle(pageRect: CGRect, titleTop: CGFloat) -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: 27.0, weight: .medium)
        let titleAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: titleFont]
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: titleAttributes
          )
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(
            x: 40,
            y: titleTop,
            width: titleStringSize.width,
            height: titleStringSize.height
        )
        attributedTitle.draw(in: titleStringRect)

        return titleStringRect.origin.y + titleStringRect.size.height
    }

    func addInvoiceHeader(
            pageRect: CGRect,
            infoTop: CGFloat,
            invoiceNo: String,
            invoiceDate: String,
            clientDetail: ClientDetail
    ) -> CGFloat {
        let boldFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        let font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        let boldAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: boldFont]
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let attrInvoiceNoTitle = NSAttributedString(
            string: "Invoice Number:",
            attributes: attributes
          )
        let attrInvoiceDateTitle = NSAttributedString(
            string: "Invoice Date:",
            attributes: attributes
          )
        let attrInvoiceNo = NSAttributedString(
            string: invoiceNo,
            attributes: attributes
          )
        let attrInvoiceDate = NSAttributedString(
            string: invoiceDate,
            attributes: attributes
          )
        let attrClientName = NSAttributedString(
            string: clientDetail.name,
            attributes: boldAttribute
          )

        let attrClientAddress = NSAttributedString(
            string: clientDetail.address,
            attributes: attributes
          )
        let attrClientCountry = NSAttributedString(
            string: clientDetail.country,
            attributes: attributes
          )
        let attrVatNo = NSAttributedString(
            string: clientDetail.vatNo,
            attributes: boldAttribute
          )
        let invoiceDateTitleStringSize = attrInvoiceDateTitle.size()
        let invoiceNoTitleStringSize = attrInvoiceNoTitle.size()
        let invoiceDateStringSize = attrInvoiceDate.size()
        let invoiceNoStringSize = attrInvoiceNo.size()
        let nameStringSize = attrClientName.size()
        let addressStringSize = attrClientAddress.size()
        let countryStringSize = attrClientCountry.size()
        let vatNoStringSize = attrVatNo.size()
        let invoiceNoTitleStringRect = CGRect(
            x: 40,
            y: infoTop,
            width: invoiceNoTitleStringSize.width,
            height: invoiceNoTitleStringSize.height
        )
        let invoiceNoStringRect = CGRect(
            x: pageRect.width / 4 + 20,
            y: infoTop,
            width: invoiceNoStringSize.width,
            height: invoiceNoStringSize.height
        )
        let invoiceDateTitleStringRect = CGRect(
            x: 40,
            y: invoiceNoTitleStringRect.origin.y + invoiceNoTitleStringRect.size.height,
            width: invoiceDateTitleStringSize.width,
            height: invoiceDateTitleStringSize.height
        )
        let invoiceDateStringRect = CGRect(
            x: pageRect.width / 4 + 20,
            y: invoiceNoStringRect.origin.y + invoiceNoStringRect.size.height,
            width: invoiceDateStringSize.width,
            height: invoiceDateStringSize.height
        )
        let nameStringRect = CGRect(
            x: pageRect.width / 1.5,
            y: infoTop,
            width: nameStringSize.width,
            height: nameStringSize.height
        )
        let addressStringRect = CGRect(
            x: pageRect.width / 1.5,
            y: nameStringRect.origin.y + nameStringRect.size.height,
            width: addressStringSize.width,
            height: addressStringSize.height
        )
        let countryStringRect = CGRect(
            x: pageRect.width / 1.5,
            y: addressStringRect.origin.y + addressStringRect.size.height,
            width: addressStringSize.width,
            height: addressStringSize.height
        )
        let vatNoStringRect = CGRect(
            x: pageRect.width / 1.5,
            y: countryStringRect.origin.y + countryStringRect.size.height,
            width: vatNoStringSize.width,
            height: vatNoStringSize.height
        )
        attrInvoiceNoTitle.draw(in: invoiceNoTitleStringRect)
        attrInvoiceNo.draw(in: invoiceNoStringRect)
        attrInvoiceDateTitle.draw(in: invoiceDateTitleStringRect)
        attrInvoiceDate.draw(in: invoiceDateStringRect)
        attrClientName.draw(in: nameStringRect)
        attrClientAddress.draw(in: addressStringRect)
        attrClientCountry.draw(in: countryStringRect)
        attrVatNo.draw(in: vatNoStringRect)
        return vatNoStringRect.origin.y + vatNoStringRect.size.height
    }

    func addInvoiceTableHeader(pageRect: CGRect, infoTop: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let attrItem = NSAttributedString(
            string: "Item",
            attributes: attributes
          )
        let attrDescription = NSAttributedString(
            string: "Description",
            attributes: attributes
          )
        let attrUnitCost = NSAttributedString(
            string: "Unit cost",
            attributes: attributes
          )
        let attrQuantity = NSAttributedString(
            string: "Quantity",
            attributes: attributes
          )
        let attrLineTotal = NSAttributedString(
            string: "Line Total",
            attributes: attributes
          )
        let itemStringSize = attrItem.size()
        let descriptionStringSize = attrDescription.size()
        let unitStringSize = attrUnitCost.size()
        let quanityNoStringSize = attrQuantity.size()
        let lineTotalStringSize = attrLineTotal.size()
        let itemStringRect = CGRect(
            x: 40,
            y: infoTop,
            width: itemStringSize.width,
            height: itemStringSize.height
        )
        let descriptionStringRect = CGRect(
            x: itemStringRect.origin.y + 20,
            y: infoTop,
            width: descriptionStringSize.width,
            height: descriptionStringSize.height
        )
        let unitStringRect = CGRect(
            x: descriptionStringRect.origin.y + 20,
            y: infoTop,
            width: unitStringSize.width,
            height: unitStringSize.height
        )
        let quantityStringRect = CGRect(
            x: unitStringRect.origin.y + 20,
            y: infoTop,
            width: quanityNoStringSize.width,
            height: quanityNoStringSize.height
        )
        let lineTotalStringRect = CGRect(
            x: pageRect.width - 40 - lineTotalStringSize.width,
            y: infoTop,
            width: lineTotalStringSize.width,
            height: lineTotalStringSize.height
        )
        attrItem.draw(in: itemStringRect)
        attrDescription.draw(in: descriptionStringRect)
        attrUnitCost.draw(in: unitStringRect)
        attrQuantity.draw(in: quantityStringRect)
        attrLineTotal.draw(in: lineTotalStringRect)

        return itemStringRect.origin.y + itemStringRect.size.height
    }

    func addCompanyInfo(pageRect: CGRect, infoTop: CGFloat, name: String, address: String, vatNo: String) -> CGFloat {
        let nameFont = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        let detailFont = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        let nameAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: nameFont]
        let detailAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: detailFont]

        let attributedName = NSAttributedString(
            string: name,
            attributes: nameAttributes
          )
        let attributedAddress = NSAttributedString(
            string: address,
            attributes: detailAttributes
          )
        let attributedVatNo = NSAttributedString(
            string: vatNo,
            attributes: detailAttributes
          )

        let nameStringSize = attributedName.size()
        let addressStringSize = attributedAddress.size()
        let vatNoStringSize = attributedVatNo.size()

        let nameStringRect = CGRect(
            x: (pageRect.width - nameStringSize.width) - 30,
            y: infoTop,
            width: nameStringSize.width,
            height: nameStringSize.height
        )
        let adressStringRect = CGRect(
            x: (pageRect.width - addressStringSize.width) - 30,
            y: nameStringRect.origin.y + nameStringRect.size.height,
            width: addressStringSize.width,
            height: addressStringSize.height
        )
        let vatNoStringRect = CGRect(
            x: (pageRect.width - vatNoStringSize.width) - 30,
            y: adressStringRect.origin.y + adressStringRect.size.height,
            width: vatNoStringSize.width,
            height: vatNoStringSize.height
        )
        attributedName.draw(in: nameStringRect)
        attributedAddress.draw(in: adressStringRect)
        attributedVatNo.draw(in: vatNoStringRect)

        let height = nameStringRect.origin.y + nameStringRect.size.height +
                    adressStringRect.origin.y + adressStringRect.size.height +
                    vatNoStringRect.origin.y + vatNoStringRect.size.height

        return height
    }

    func addBodyText(pageRect: CGRect, textTop: CGFloat) {
      let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .natural
      paragraphStyle.lineBreakMode = .byWordWrapping
      let textAttributes = [
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.font: textFont
      ]
      let attributedText = NSAttributedString(
        string: body,
        attributes: textAttributes
      )
      let textRect = CGRect(
        x: 20,
        y: textTop,
        width: pageRect.width - 20,
        height: pageRect.height - textTop - pageRect.height / 5.0
      )
      attributedText.draw(in: textRect)
    }

    func drawTableLines(_ drawContext: CGContext, pageRect: CGRect, lineTop: CGFloat) {
        drawContext.saveGState()
        drawContext.setLineWidth(0.5)

        drawContext.move(to: CGPoint(x: 40, y: lineTop))
        drawContext.addLine(to: CGPoint(x: pageRect.width - 40, y: lineTop))
        drawContext.strokePath()
        drawContext.restoreGState()

        drawContext.saveGState()
        let dashLength = CGFloat(72.0 * 0.2)
        drawContext.setLineDash(phase: 0, lengths: [dashLength, dashLength])
        drawContext.restoreGState()
    }

    func addLogo(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
        let maxHeight = 100.0
        let maxWidth = 200.0
      let aspectWidth = maxWidth / image.size.width
      let aspectHeight = maxHeight / image.size.height
      let aspectRatio = min(aspectWidth, aspectHeight)
      let scaledWidth = image.size.width * aspectRatio
      let scaledHeight = image.size.height * aspectRatio
        let imageX = 10.0
      let imageRect = CGRect(x: imageX, y: imageTop,
                             width: scaledWidth, height: scaledHeight)
      image.draw(in: imageRect)
      return imageRect.origin.y + imageRect.size.height
    }
}
