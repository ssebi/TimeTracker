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
                infoTop: titleBottom + 8.0,
                invoiceNo: invoice.invoiceNumber,
                invoiceDate: "20-02-2022",
                clientDetail: clientDetail
            )
            let invoiceTableHeaderBottom = addInvoiceTableHeader(pageRect: pageRect, infoTop: invoiceHeaderBottom + 100)
            let context = context.cgContext
            drawTableLines(context, pageRect: pageRect, lineTop: titleBottom)
            drawTableLines(context, pageRect: pageRect, lineTop: invoiceHeaderBottom + 10.0)
            drawTableLines(context, pageRect: pageRect, lineTop: invoiceTableHeaderBottom + 10.0)
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
            clientDetail: ClientDetail
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
		let vat = PDFElement(text: clientDetail.vatNo,
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
            x: itemStringRect.origin.x + itemStringRect.width + 20,
            y: infoTop,
            width: descriptionStringSize.width,
            height: descriptionStringSize.height
        )
        let unitStringRect = CGRect(
            x: descriptionStringRect.origin.x + descriptionStringRect.width * 2.5,
            y: infoTop,
            width: unitStringSize.width,
            height: unitStringSize.height
        )
        let quantityStringRect = CGRect(
            x: unitStringRect.origin.x + unitStringRect.width + 20,
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

		func attributes() -> [NSAttributedString.Key: Any] {
			switch self {
				case .largeTitle:
					return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27.0, weight: .medium)]

				case .headline:
					return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)]

				case .body:
					return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)]
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
