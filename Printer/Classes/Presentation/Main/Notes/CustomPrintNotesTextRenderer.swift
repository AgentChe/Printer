import Foundation
import UIKit

class CustomPrintNotesTextRenderer: UIPrintPageRenderer {
    var copies: Int = 1
     var pagesPerSheet: Int = 1
     var printText: String = "Default text to print"  // This should be replaced with attributed text handling
     var attributedPrintText: NSAttributedString? // New variable for attributed text
     var textAlignment: NSTextAlignment = .left  // Default alignment is left

    override init() {
        super.init()
        self.headerHeight = 20.0
        self.footerHeight = 20.0
    }

    override var numberOfPages: Int {
        return Int(ceil(Double(copies) / Double(pagesPerSheet)))
    }

    override func drawPage(at pageIndex: Int, in printableRect: CGRect) {
        let startCopyIndex = pageIndex * pagesPerSheet
        let endCopyIndex = min(startCopyIndex + pagesPerSheet, copies) - 1

        let cols = Int(ceil(sqrt(Double(pagesPerSheet))))
        let rows = Int(ceil(Double(pagesPerSheet) / Double(cols)))

        let virtualPageWidth = printableRect.width / CGFloat(cols)
        let virtualPageHeight = printableRect.height / CGFloat(rows)

        var currentCopy = startCopyIndex
        for row in 0..<rows {
                  for col in 0..<cols {
                      if currentCopy > endCopyIndex {
                          break
                      }
                      let x = printableRect.origin.x + CGFloat(col) * virtualPageWidth
                      let y = printableRect.origin.y + CGFloat(row) * virtualPageHeight
                      let virtualPageRect = CGRect(x: x, y: y, width: virtualPageWidth, height: virtualPageHeight)
                      if let attributedText = attributedPrintText {
                          drawAttributedText(in: virtualPageRect, text: attributedText)
                      } else {
                          drawText(in: virtualPageRect, text: printText, alignment: textAlignment)
                      }
                      currentCopy += 1
                  }
              }
    }

    private func drawText(in rect: CGRect, text: String, alignment: NSTextAlignment) {
        var fontSize = min(12, max(rect.width, rect.height) / 4)  // Start with a reasonable font size
        var attributes: [NSAttributedString.Key: Any]
        var textSize: CGSize
        var fits: Bool

        repeat {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment

            attributes = [
                .font: UIFont.systemFont(ofSize: CGFloat(fontSize)),
                .paragraphStyle: paragraphStyle
            ]

            textSize = (text as NSString).boundingRect(
                with: CGSize(width: rect.width - 20, height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: attributes,
                context: nil
            ).size

            fits = textSize.height <= rect.height - 20 && textSize.width <= rect.width - 20
            if !fits {
                fontSize -= 0.5
            }
        } while !fits && fontSize > 2

        let topMargin: CGFloat = (rect.height - textSize.height) / 2  // Center the text vertically
        let textRect = CGRect(
            x: rect.origin.x + 10,
            y: rect.origin.y + topMargin,
            width: rect.width - 20,
            height: textSize.height
        )
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(in: textRect)
    }

    private func drawAttributedText(in rect: CGRect, text: NSAttributedString) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment

        var fontSize = min(12, max(rect.width, rect.height) / 4)  // Start with a reasonable font size
        var attributes = text.attributes(at: 0, effectiveRange: nil)
        attributes[.paragraphStyle] = paragraphStyle

        var textSize: CGSize
        var fits: Bool

        repeat {
            attributes[.font] = UIFont.systemFont(ofSize: CGFloat(fontSize))
            let attributedText = NSAttributedString(string: text.string, attributes: attributes)

            textSize = attributedText.boundingRect(
                with: CGSize(width: rect.width - 20, height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                context: nil
            ).size

            fits = textSize.height <= rect.height - 20 && textSize.width <= rect.width - 20
            if (!fits) {
                fontSize -= 0.5
            }
        } while !fits && fontSize > 2

        let topMargin: CGFloat = (rect.height - textSize.height) / 2  // Center the text vertically
        let textRect = CGRect(
            x: rect.origin.x + 10,
            y: rect.origin.y + topMargin,
            width: rect.width - 20,
            height: textSize.height
        )
        let finalAttributedText = NSAttributedString(string: text.string, attributes: attributes)
        finalAttributedText.draw(in: textRect)
    }

   
}


// Extension for PDF data creation remains unchanged
extension UIPrintPageRenderer {
    func pdfData() -> Data {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        self.prepare(forDrawingPages: NSMakeRange(0, self.numberOfPages))

        let bounds = UIGraphicsGetPDFContextBounds()
        for i in 0..<self.numberOfPages {
            UIGraphicsBeginPDFPage()
            self.drawPage(at: i, in: bounds)
        }

        UIGraphicsEndPDFContext()
        return pdfData as Data
    }

    func createImageFromPDFData(pdfData: Data) -> UIImage? {
        guard let provider = CGDataProvider(data: pdfData as CFData),
              let pdfDoc = CGPDFDocument(provider),
              let page = pdfDoc.page(at: 1) else {
            return nil
        }

        var pageRect = page.getBoxRect(.mediaBox)
        let pdfScale = UIScreen.main.scale // Scale the PDF to screen scale
        pageRect.size = CGSize(width: pageRect.size.width * pdfScale, height: pageRect.size.height * pdfScale)

        UIGraphicsBeginImageContextWithOptions(pageRect.size, true, pdfScale)  // Changed 'false' to 'true' for opaque background
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        // Fill the background with white color
        context.setFillColor(UIColor.white.cgColor)
        context.fill(pageRect)

        context.saveGState()
        context.translateBy(x: 0.0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.scaleBy(x: pdfScale, y: pdfScale)
        context.drawPDFPage(page)
        context.restoreGState()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
