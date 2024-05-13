//
//  CustomPrintImagePageRenderer.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/13/24.
//

import UIKit
class CustomPrintImagePageRenderer: UIPrintPageRenderer {
    var copies: Int = 1
    var pagesPerSheet: Int = 1
    var printImage: UIImage = UIImage() // Default image to print

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
                drawImage(in: virtualPageRect, image: printImage)
                currentCopy += 1
            }
        }
    }

    private func drawImage(in rect: CGRect, image: UIImage) {
        let imageSize = image.size
        let targetWidth = rect.width - 20
        let targetHeight = rect.height - 20
        var scaleFactor: CGFloat

        // Determine the scale factor that maintains aspect ratio and fits within the target rectangle.
        if imageSize.width > imageSize.height {
            scaleFactor = targetWidth / imageSize.width
        } else {
            scaleFactor = targetHeight / imageSize.height
        }

        // Adjust the scale factor if the scaled image exceeds the target rectangle's bounds.
        let scaledWidth = imageSize.width * scaleFactor
        let scaledHeight = imageSize.height * scaleFactor
        if scaledWidth > targetWidth {
            scaleFactor = targetWidth / imageSize.width
        }
        if scaledHeight > targetHeight {
            scaleFactor = targetHeight / imageSize.height
        }

        // Calculate the image rectangle, centered within the target rectangle.
        let scaledImageRect = CGRect(
            x: rect.origin.x + (rect.width - scaledWidth) / 2,
            y: rect.origin.y + (rect.height - scaledHeight) / 2,
            width: scaledWidth,
            height: scaledHeight
        )

        image.draw(in: scaledImageRect)
    }
}
