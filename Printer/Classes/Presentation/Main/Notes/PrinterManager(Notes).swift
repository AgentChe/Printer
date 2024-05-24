//
//  PrinterManager(Notes).swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/22/24.
//

import UIKit

extension PrinterManager {
    func printPDFData(_ pdfData: Data, from viewController: UIViewController, to printer: UIPrinter, copies: Int, completion: @escaping (Bool) -> Void) {
        let printController = UIPrintInteractionController.shared
        
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "PDF Document"
        printInfo.outputType = .general
        printController.printInfo = printInfo
        
        printController.printingItem = pdfData
        
        printController.print(to: printer) { (controller, completed, error) in
            if completed {
                print("Printed successfully with \(printer.displayName)!")
                completion(true)
            } else {
                if let printError = error {
                    let printErrorViewController = PrintErrorViewController()
                    printErrorViewController.modalPresentationStyle = .fullScreen
                    viewController.present(printErrorViewController, animated: true, completion: nil)
                    print("Failed to print with \(printer.displayName): \(printError.localizedDescription)")
                }
                completion(false)
            }
        }
    }
}

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
                    let printErrorViewController = PrintErrorViewController()
                    printErrorViewController.modalPresentationStyle = .fullScreen
                    viewController.present(printErrorViewController, animated: true, completion: nil)
                    print("Failed to print with \(printer.displayName): \(printError.localizedDescription)")
                }
            }
        })
    }
}
