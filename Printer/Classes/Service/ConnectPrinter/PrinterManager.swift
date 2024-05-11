//
//  PrinterManager.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/11/24.
//

import UIKit

class PrinterManager {
    // Singleton instance
    static let shared = PrinterManager()

    // Private initializer to restrict instantiation outside this class
    private init() {}

    // Save a new printer with URL and display name
    func savePrinter(url: URL, displayName: String) {
        var printers = getSavedPrinters()
        printers[url.absoluteString] = displayName
        UserDefaults.standard.set(printers, forKey: "savedPrinters")
    }

    // Retrieve all saved printers as an array of UIPrinter objects
    func retrieveAllPrinters() -> [UIPrinter] {
        let printers = getSavedPrinters()
        return printers.keys.compactMap { URL(string: $0) }.map { UIPrinter(url: $0) }
    }

    // Helper function to get saved printers from UserDefaults
    private func getSavedPrinters() -> [String: String] {
        return UserDefaults.standard.dictionary(forKey: "savedPrinters") as? [String: String] ?? [:]
    }

    // Check if there are any printers saved
    func hasSavedPrinters() -> Bool {
        let printers = getSavedPrinters()
        return !printers.isEmpty
    }
    func getPrinterName(for url: URL) -> String? {
          let printers = getSavedPrinters()
          return printers[url.absoluteString]
      }
    // Example function to print a document with each printer
    func printDocumentWithAllPrinters(from viewController: UIViewController) {
        let printers = retrieveAllPrinters()
        printers.forEach { printer in
            printDocument(printer: printer, from: viewController)
        }
    }
    

    // Print a document with a specific printer
    func printDocument(printer: UIPrinter, from viewController: UIViewController) {
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "My Document"
        printInfo.outputType = .general

        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo

        let printFormatter = UIMarkupTextPrintFormatter(markupText: "<h1>Hello, world!</h1>")
        printController.printFormatter = printFormatter

        printController.printingItem = printer

        printController.present(from: viewController.view.frame, in: viewController.view, animated: true) {
            (printController, completed, error) in
            if completed, error == nil {
                print("Printed successfully with \(printer.displayName)!")
            } else {
                print("Failed to print with \(printer.displayName): \(String(describing: error))")
            }
        }
    }
}
