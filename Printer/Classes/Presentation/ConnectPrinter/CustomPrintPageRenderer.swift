//
//  CustomPrintPageRenderer.swift
//  Pods
//
//  Created by Niiaz Khasanov on 5/13/24.
//

import UIKit
class CustomPrintPageRenderer: UIPrintPageRenderer {
    var copies: Int = 1  // Total number of copies of the content
    var pagesPerSheet: Int = 1  // Number of virtual pages per physical sheet

    override init() {
        super.init()
        self.headerHeight = 20.0
        self.footerHeight = 20.0
    }

    override var numberOfPages: Int {
        // Calculate the number of physical pages needed
        return Int(ceil(Double(copies) / Double(pagesPerSheet)))
    }

    override func drawPage(at pageIndex: Int, in printableRect: CGRect) {
        let startCopyIndex = pageIndex * pagesPerSheet
        let endCopyIndex = min(startCopyIndex + pagesPerSheet, copies) - 1

        // Calculate dimensions for each virtual page within the physical page
        let virtualPageHeight = printableRect.height / CGFloat(pagesPerSheet)
        let virtualPageWidth = printableRect.width

        for copyIndex in startCopyIndex...endCopyIndex {
            let offset = CGFloat(copyIndex - startCopyIndex) * virtualPageHeight
            let virtualPageRect = CGRect(
                x: printableRect.origin.x,
                y: printableRect.origin.y + offset,
                width: virtualPageWidth,
                height: virtualPageHeight
            )
            drawText(in: virtualPageRect, text: "Text for copy \(copyIndex + 1)")
        }
    }

    private func drawText(in rect: CGRect, text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textRect = rect.insetBy(dx: 10, dy: 10)
        attributedString.draw(in: textRect)
    }
}
