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
                drawText(in: virtualPageRect, text: "Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.Copy \(currentCopy + 1): This approach should now correctly map the number of virtual pages per physical sheet and draw the specified number of copies accordingly. If this still doesn't resolve the issue, consider examining the setup in which the renderer is used, including the print initiation context, to ensure it's being used correctly.", cols: cols, rows: rows)
                currentCopy += 1
            }
        }
    }

    private func drawText(in rect: CGRect, text: String, cols: Int, rows: Int) {
        // Определяем начальный размер шрифта на основе размера области и количества столбцов и строк
        var fontSize = min(12, max(rect.width, rect.height) / CGFloat(cols * rows)) // Начальный размер шрифта
        var attributes: [NSAttributedString.Key: Any]
        var textSize: CGSize
        var fits: Bool

        // Цикл для уменьшения размера шрифта до тех пор, пока текст не поместится в область
        repeat {
            attributes = [
                .font: UIFont.systemFont(ofSize: CGFloat(fontSize)),
                .paragraphStyle: NSMutableParagraphStyle()
            ]
            (attributes[.paragraphStyle] as! NSMutableParagraphStyle).alignment = .center

            // Используем boundingRect для расчета размера текста с текущими настройками шрифта
            textSize = (text as NSString).boundingRect(with: CGSize(width: rect.width - 20, height: CGFloat.greatestFiniteMagnitude),
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: attributes,
                                                       context: nil).size

            // Проверяем, помещается ли текст в заданную высоту и ширину
            fits = textSize.height <= rect.height - 20 && textSize.width <= rect.width - 20
            if !fits {
                fontSize -= 0.5  // Уменьшаем размер шрифта на 0.5 пункта за итерацию
            }
        } while !fits && fontSize > 1  // Устанавливаем новый более мелкий минимальный порог для размера шрифта

        // Определяем положение текста в области
        let textRect = CGRect(x: rect.origin.x + 10, y: rect.origin.y + (rect.height - textSize.height) / 2,
                              width: rect.width - 20, height: textSize.height)
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(in: textRect)
    }
}
