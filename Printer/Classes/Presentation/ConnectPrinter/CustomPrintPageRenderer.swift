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

        // Determine the number of rows and columns
        let cols = Int(ceil(sqrt(Double(pagesPerSheet))))
        let rows = Int(ceil(Double(pagesPerSheet) / Double(cols)))

        // Calculate dimensions for each virtual page within the physical page
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
                drawText(in: virtualPageRect, text: "This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly. \(currentCopy + 1)")
                currentCopy += 1
            }
        }
    }

    private func drawText(in rect: CGRect, text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),  // Adjust font size if necessary
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textRect = rect.insetBy(dx: 10, dy: 10)  // Adjust text positioning within each virtual page
        attributedString.draw(in: textRect)
    }
}
