import Foundation
import UIKit

class CustomPrintNotesTextRenderer: UIPrintPageRenderer {
    var copies: Int = 1
    var pagesPerSheet: Int = 1
    var attributedPrintText: NSAttributedString? // Attributed text to be printed
    var textAlignment: NSTextAlignment = .left  // Default text alignment

    override init() {
        super.init()
        self.headerHeight = 20.0
        self.footerHeight = 20.0
    }

    override var numberOfPages: Int {
        guard let attributedText = attributedPrintText else { return 1 }
        return calculatePageCount(for: attributedText)
    }

    private func calculatePageCount(for text: NSAttributedString) -> Int {
        let textContainer = NSTextContainer(size: CGSize(width: paperRect.width - 40, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: text)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        var range = NSRange(location: 0, length: layoutManager.numberOfGlyphs)
        var pages = 0

        while range.length > 0 {
            let glyphRange = layoutManager.glyphRange(forBoundingRect: CGRect(x: 0, y: 0, width: paperRect.width - 40, height: paperRect.height - headerHeight - footerHeight), in: textContainer)
            range = NSRange(location: range.location + glyphRange.length, length: range.length - glyphRange.length)
            pages += 1
        }

        return pages
    }

    override func drawPage(at pageIndex: Int, in printableRect: CGRect) {
        guard let attributedText = attributedPrintText else { return }
        let textContainer = NSTextContainer(size: CGSize(width: printableRect.width - 20, height: printableRect.height - 20))
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        var startGlyphIndex = 0
        var currentStart = 0

        // Calculate the starting glyph for each page
        for pageIndex in 0..<pageIndex {
            let glyphRange = layoutManager.glyphRange(forBoundingRect: CGRect(origin: CGPoint.zero, size: textContainer.size), in: textContainer)
            currentStart += glyphRange.length
        }
        
        // Determine the range of glyphs to draw for the current page
        let glyphRange = layoutManager.glyphRange(forBoundingRect: CGRect(origin: CGPoint.zero, size: textContainer.size), in: textContainer)
        startGlyphIndex = currentStart

        let drawingRect = CGRect(x: printableRect.origin.x + 10, y: printableRect.origin.y + 10, width: printableRect.width - 20, height: printableRect.height - 20)

        layoutManager.drawBackground(forGlyphRange: NSRange(location: startGlyphIndex, length: glyphRange.length), at: CGPoint(x: drawingRect.origin.x, y: drawingRect.origin.y))
        layoutManager.drawGlyphs(forGlyphRange: NSRange(location: startGlyphIndex, length: glyphRange.length), at: CGPoint(x: drawingRect.origin.x, y: drawingRect.origin.y))
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
