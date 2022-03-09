//
//  PdfCreator.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 28.01.2022.
//

import PDFKit

final class InvoiceCreator {
	let leftPadding: CGFloat = 40

    let title: String
    let image: UIImage
    let clientDetail: ClientBillingInfo

    init(title: String, image: UIImage, clientDetail: ClientBillingInfo) {
        self.title = title
        self.image = image
        self.clientDetail = clientDetail
    }

    func createInvoice(invoice: InvoiceDetails) -> Data {
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

            let logo = addLogo(pageRect: pageRect, imageTop: 40)
            let titleBottom = addTitle(pageRect: pageRect, titleTop: logo + 60.0)
            let context = context.cgContext

            addCompanyInfo(
                pageRect: pageRect,
                infoTop: 40.0,
                name: "Parhelion",
                address: "Moldovei 3",
                vatNo: "RO4323455"
            )
            let invoiceHeaderBottom = addInvoiceHeader(
                pageRect: pageRect,
                infoTop: titleBottom + 8.0,
                invoiceNo: invoice.invoiceNumber,
                invoiceDate: invoice.invoiceDate,
                clientDetail: clientDetail
            )

            let invoiceTableHeaderBottom = addInvoiceTableHeader(pageRect: pageRect, infoTop: invoiceHeaderBottom + 100)
            let invoiceBodyBottom = addInvoiceBody(
                pageRect: pageRect,
                infoTop: invoiceTableHeaderBottom + 10.0,
                unitCost: "$\(invoice.unitCost)",
                quantity: "\(invoice.quantity / 60) h",
                lineTotal: "$\(invoice.unitCost * invoice.quantity)",
                product: invoice.product,
                invoiceTotal: "$\(invoice.unitCost * (invoice.quantity / 60))")

            drawTableLines(context, pageRect: pageRect, lineTop: titleBottom)
            drawTableLines(context, pageRect: pageRect, lineTop: invoiceHeaderBottom)
            drawTableLines(context, pageRect: pageRect, lineTop: invoiceTableHeaderBottom)
            drawTableLines(context, pageRect: pageRect, lineTop: invoiceBodyBottom)
        }

        return data
    }

    func addTitle(pageRect: CGRect, titleTop: CGFloat) -> CGFloat {
		PDFElement(text: title, style: .largeTitle, originX: leftPadding, originY: titleTop).drawText()
    }

    func addInvoiceHeader(
            pageRect: CGRect,
            infoTop: CGFloat,
            invoiceNo: String,
            invoiceDate: String,
            clientDetail: ClientBillingInfo
    ) -> CGFloat {
		let invoiceNoTitle = PDFElement(text: "Invoice Number:",
									   originX: leftPadding,
									   originY: infoTop)
		let invoiceDateTitle = PDFElement(text: "Invoice Date:",
										 originX: leftPadding,
										 originY: invoiceNoTitle.rect.origin.y + invoiceNoTitle.rect.size.height)
		let invoiceNoValue = PDFElement(text: invoiceNo,
									   originX: pageRect.width / 4 + 20,
									   originY: infoTop)
		let invoiceDateValue = PDFElement(text: invoiceDate,
										 originX: pageRect.width / 4 + 20,
										 originY: invoiceNoValue.rect.origin.y + invoiceNoValue.rect.size.height)
		let clientName = PDFElement(text: clientDetail.name,
								   style: .headline,
								   originX: pageRect.width / 1.5,
								   originY: infoTop)
		let clientAddress = PDFElement(text: clientDetail.address,
									  originX: pageRect.width / 1.5,
									  originY: clientName.rect.origin.y + clientName.rect.size.height)
        let clientCountry = PDFElement(text: clientDetail.country,
									  originX: pageRect.width / 1.5,
									  originY: clientAddress.rect.origin.y + clientAddress.rect.size.height)
		let vat = PDFElement(text: clientDetail.vat,
							style: .headline,
							originX: pageRect.width / 1.5,
							originY: clientCountry.rect.origin.y + clientCountry.rect.size.height)

		let arr = [
			invoiceNoTitle,
			invoiceDateTitle,
			invoiceNoValue,
			invoiceDateValue,
			clientName,
			clientAddress,
			clientCountry,
			vat
		].map { component in
			component.drawText()
		}

		return arr[arr.count - 1]
	}

    func addInvoiceTableHeader(pageRect: CGRect, infoTop: CGFloat) -> CGFloat {
        let item = PDFElement(text: "Item",
                              style: .title3,
                              originX: leftPadding,
                              originY: infoTop)
        let description = PDFElement(text: "Description",
                                     style: .title3,
                                     originX: pageRect.width / 7.5,
                                     originY: infoTop)
        let unitCost = PDFElement(text: "Unit cost",
                                  style: .title3,
                                  originX: description.rect.origin.x + description.rect.width * 2.5,
                                  originY: infoTop)
        let quantity = PDFElement(text: "Quantity",
                                  style: .title3,
                                  originX: unitCost.rect.origin.x + unitCost.rect.width + 30,
                                  originY: infoTop)
        let lineTotal = PDFElement(text: "Line Total",
                                   style: .title3,
                                   originX: pageRect.width - 110,
                                   originY: infoTop)

        let arr = [
            item,
            description,
            unitCost,
            quantity,
            lineTotal
        ].map { component in
            component.drawText()
        }

        return arr[arr.count - 1]
	}

    func addInvoiceBody(pageRect: CGRect,
                        infoTop: CGFloat,
                        unitCost: String,
                        quantity: String,
                        lineTotal: String,
                        product: String,
                        invoiceTotal: String
                        ) -> CGFloat {
        let itemNo = PDFElement(text: "1",
                              originX: 50,
                              originY: infoTop)
        let description = PDFElement(text: product,
                                     originX: pageRect.width / 7.5,
                                     originY: infoTop)
        let unitCost = PDFElement(text: unitCost,
                                  originX: pageRect.width / 2 + 10.0,
                                  originY: infoTop)
        let quantity = PDFElement(text: quantity,
                                  originX: pageRect.width / 1.5,
                                  originY: infoTop)
        let lineTotal = PDFElement(text: lineTotal,
                                   originX: pageRect.width - 110,
                                   originY: infoTop)
        let invoiceTotal = PDFElement(text: "Total:  \(invoiceTotal)",
                                   originX: pageRect.width - 150,
                                      originY: lineTotal.rect.origin.y + 50)

        let arr = [
            itemNo,
            description,
            unitCost,
            quantity,
            lineTotal,
            invoiceTotal
        ].map { component in
            component.drawText()
        }

        return arr[arr.count - 2]
    }

    func addCompanyInfo(pageRect: CGRect, infoTop: CGFloat, name: String, address: String, vatNo: String) {
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
        let imageX = 40.0
      let imageRect = CGRect(x: imageX, y: imageTop,
                             width: scaledWidth, height: scaledHeight)
      image.draw(in: imageRect)
      return imageRect.origin.y + imageRect.size.height
    }
}

private struct PDFElement {
	enum PDFFontStyle {
		case largeTitle
		case headline
		case body
        case title3

		func attributes() -> [NSAttributedString.Key: Any] {
			switch self {
                case .largeTitle:
                    return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27.0, weight: .medium)]
                case .headline:
                    return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)]
                case .body:
                    return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)]
                case .title3:
                    return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .bold)]
			}
		}
	}

	let bottomPadding: CGFloat = 10

	var text: String
	var rect: CGRect

	private var style: PDFFontStyle
	private var attributesText: NSAttributedString {
		NSAttributedString(string: text, attributes: style.attributes())
	}

	init() {
		text = ""
		rect = CGRect()
		style = .body
	}

	init(text: String, style: PDFFontStyle = .body, originX: CGFloat, originY: CGFloat) {
		self.init()
		self.text = text
		self.style = style
		let size = attributesText.size()
		rect = CGRect(x: originX, y: originY, width: size.width, height: size.height)
	}

	@discardableResult
	func drawText() -> CGFloat {
		attributesText.draw(in: rect)
		return rect.origin.y + rect.size.height + bottomPadding
	}
}
