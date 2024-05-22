//
//  PrinterManager(Notes).swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/22/24.
//

import UIKit
extension PrinterManager {
    func directPrintTextUsingRenderer(from viewController: UIViewController, printer: UIPrinter, copies: Int, pagesPerSheet: Int, renderer: CustomPrintNotesTextRenderer) {
        let printController = UIPrintInteractionController.shared

        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "Direct Print Job"
        printInfo.outputType = .general
        printInfo.orientation = .portrait
        printInfo.duplex = .longEdge

        renderer.copies = copies * pagesPerSheet
        renderer.pagesPerSheet = pagesPerSheet
        // renderer.printText = text // Установка текста для печати

        printController.printPageRenderer = renderer
        printController.printInfo = printInfo

        printController.print(to: printer, completionHandler: { _, completed, error in
            if completed {
                print("Printed successfully with \(printer.displayName)!")
            } else {
                if let printError = error {
                    print("Failed to print with \(printer.displayName): \(printError.localizedDescription)")
                }
            }
        })
    }
}
