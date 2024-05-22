//
//  PhotosPrinterManager.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/22/24.
//

import UIKit
extension PrinterManager {
    func directPrintPhotoUsingRenderer(from viewController: UIViewController, printer: UIPrinter, copies: Int, pagesPerSheet: Int, images: [UIImage], renderer: CustomPhotoPrintPageRenderer) {
        let printController = UIPrintInteractionController.shared

        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "Direct Print Photo Job"
        printInfo.outputType = .photo
        printInfo.orientation = .portrait
        printInfo.duplex = .longEdge

        renderer.copies = copies * pagesPerSheet
        renderer.pagesPerSheet = pagesPerSheet
        renderer.photos = images // Setting the photos for printing

        printController.printPageRenderer = renderer
        printController.printInfo = printInfo

        printController.print(to: printer, completionHandler: { _, completed, error in
            if completed {
                print("Photos printed successfully with \(printer.displayName)!")
            } else {
                if let printError = error {
                    print("Failed to print photos with \(printer.displayName): \(printError.localizedDescription)")
                }
            }
        })
    }
}
