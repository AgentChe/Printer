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
        let cols: Int
        let rows: Int
        
        switch pagesPerSheet {
        case 6:
            cols = 2
            rows = 3
        case 9:
            cols = 3
            rows = 3
        case 16:
            cols = 4
            rows = 4
        case 2:
            cols = 1
            rows = 2
        default:
            cols = Int(ceil(sqrt(Double(pagesPerSheet))))
            rows = Int(ceil(Double(pagesPerSheet) / Double(cols)))
        }

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
        let aspectRatio = imageSize.width / imageSize.height
        let isApprox3x4AspectRatio = (aspectRatio >= 2.5 / 4.0) && (aspectRatio <= 3.5 / 4.0)
        let isApprox19_5x9AspectRatio = (aspectRatio >= 8.5 / 19.5) && (aspectRatio <= 9.5 / 19.5)

        let shouldRotate = ((pagesPerSheet == 2 || pagesPerSheet == 6) && isApprox3x4AspectRatio) ||
                           (pagesPerSheet == 2 && isApprox19_5x9AspectRatio)

        // Calculate scale factor to fit the image within the rect
        let scaleFactor: CGFloat
        if shouldRotate {
            scaleFactor = min(rect.width / imageSize.height, rect.height / imageSize.width)
        } else {
            scaleFactor = min(rect.width / imageSize.width, rect.height / imageSize.height)
        }

        let scaledWidth = shouldRotate ? imageSize.height * scaleFactor : imageSize.width * scaleFactor
        let scaledHeight = shouldRotate ? imageSize.width * scaleFactor : imageSize.height * scaleFactor

        // Define the rectangle where the image will be drawn
        var imageRect = CGRect(
            x: rect.origin.x + (rect.width - scaledWidth) / 2,
            y: rect.origin.y + (rect.height - scaledHeight) / 2,
            width: scaledWidth,
            height: scaledHeight
        )

        if shouldRotate {
            UIGraphicsGetCurrentContext()?.saveGState()
            UIGraphicsGetCurrentContext()?.translateBy(x: rect.midX, y: rect.midY)
            UIGraphicsGetCurrentContext()?.rotate(by: CGFloat.pi / 2)

            imageRect = CGRect(
                x: -scaledHeight / 2,
                y: -scaledWidth / 2,
                width: scaledHeight,
                height: scaledWidth
            )

            image.draw(in: imageRect)
            UIGraphicsGetCurrentContext()?.restoreGState()
        } else {
            image.draw(in: imageRect)
        }
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
