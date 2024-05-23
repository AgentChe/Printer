import UIKit

class CustomScanPrintPageRenderer: UIPrintPageRenderer {

    var photos: [UIImage] = []
    var copies: Int = 1
    var pagesPerSheet: Int = 1

    // Define the page frame and content frame
    override var paperRect: CGRect {
        return CGRect(x: 0, y: 0, width: 612, height: 792) // A4 size paper
    }

    override var printableRect: CGRect {
        return CGRect(x: 20, y: 20, width: 572, height: 752)
    }
    
    override var numberOfPages: Int {
        return Int(ceil(Double(photos.count * copies) / Double(pagesPerSheet)))
    }

    override func drawPage(at pageIndex: Int, in printableRect: CGRect) {
        let cols = Int(ceil(sqrt(Double(pagesPerSheet))))
        let rows = Int(ceil(Double(pagesPerSheet) / Double(cols)))

        let virtualPageWidth = printableRect.width / CGFloat(cols)
        let virtualPageHeight = printableRect.height / CGFloat(rows)

        for row in 0..<rows {
            for col in 0..<cols {
                let imageIndex = pageIndex * pagesPerSheet + row * cols + col
                if imageIndex >= photos.count * copies {
                    return
                }
                let photoIndex = imageIndex / copies
                let image = photos[photoIndex]

                let x = printableRect.origin.x + CGFloat(col) * virtualPageWidth
                let y = printableRect.origin.y + CGFloat(row) * virtualPageHeight
                let virtualPageRect = CGRect(x: x, y: y, width: virtualPageWidth, height: virtualPageHeight)
                drawImage(in: virtualPageRect, image: image)
            }
        }
    }

    private func drawImage(in rect: CGRect, image: UIImage) {
        let imageSize = image.size
        let scaleFactor = min(rect.width / imageSize.width, rect.height / imageSize.height)

        let scaledWidth = imageSize.width * scaleFactor
        let scaledHeight = imageSize.height * scaleFactor

        let imageRect = CGRect(
            x: rect.origin.x + (rect.width - scaledWidth) / 2,
            y: rect.origin.y, // Pin to the top of the virtual page rect
            width: scaledWidth,
            height: scaledHeight
        )

        image.draw(in: imageRect)
    }

    // Helper function to get aspect fit size
    private func aspectFitSizeForImage(_ imageSize: CGSize, inRect rect: CGRect) -> CGSize {
        let widthRatio = rect.width / imageSize.width
        let heightRatio = rect.height / imageSize.height
        let scale = min(widthRatio, heightRatio)

        let aspectFitSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        return aspectFitSize
    }
}
