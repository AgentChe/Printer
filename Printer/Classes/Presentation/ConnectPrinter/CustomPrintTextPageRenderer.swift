//
//  CustomPrintPageRenderer.swift
//  Pods
//
//  Created by Niiaz Khasanov on 5/13/24.
//

import UIKit
class CustomPrintTextPageRenderer: UIPrintPageRenderer {
    var copies: Int = 1
    var pagesPerSheet: Int = 1
    var printText: String = "Default text to print" // Новое свойство для текста

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
                drawText(in: virtualPageRect, text: "\(printText)", cols: cols, rows: rows)
                currentCopy += 1
            }
        }
    }

    private func drawText(in rect: CGRect, text: String, cols: Int, rows: Int) {
        var fontSize = min(12, max(rect.width, rect.height) / CGFloat(cols * rows))
        var attributes: [NSAttributedString.Key: Any]
        var textSize: CGSize
        var fits: Bool

        repeat {
            attributes = [
                .font: UIFont.systemFont(ofSize: CGFloat(fontSize)),
                .paragraphStyle: NSMutableParagraphStyle()
            ]
            (attributes[.paragraphStyle] as! NSMutableParagraphStyle).alignment = .center

            textSize = (text as NSString).boundingRect(with: CGSize(width: rect.width - 20, height: CGFloat.greatestFiniteMagnitude),
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: attributes,
                                                       context: nil).size

            fits = textSize.height <= rect.height - 20 && textSize.width <= rect.width - 20
            if !fits {
                fontSize -= 0.5
            }
        } while !fits && fontSize > 2

        let textRect = CGRect(x: rect.origin.x + 10, y: rect.origin.y + (rect.height - textSize.height) / 2,
                              width: rect.width - 20, height: textSize.height)
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(in: textRect)
    }
}
