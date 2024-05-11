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

    // Memory-only variable for currently connected printer URL
     var currentlyConnectedPrinterURL: URL?
    
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
extension PrinterManager {
    // Connect to a printer by URL and return a UIPrinter object
    func connectToPrinter(with url: URL, completion: @escaping (UIPrinter?, Error?) -> Void) {
        let savedPrinters = getSavedPrinters()

        guard let displayName = savedPrinters[url.absoluteString] else {
            completion(nil, NSError(domain: "PrinterManagerError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Printer not found."]))
            showAlertForErrorWithPrinter("Unknown")
            return
        }

        let printer = UIPrinter(url: url)
        printer.contactPrinter { [self] success in
            if success {
                self.lastConnectedPrinter = url
                self.currentlyConnectedPrinterURL = url
                completion(printer, nil)
            } else {
                self.currentlyConnectedPrinterURL = nil
                completion(nil, NSError(domain: "PrinterManagerError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to contact printer."]))
                showAlertForErrorWithPrinter(displayName)
            }
        }
    }
    func disconnectPrinter() {
        self.currentlyConnectedPrinterURL = nil
    }

}
extension PrinterManager {
    // Property to get and set the last connected printer URL
    var lastConnectedPrinter: URL? {
        get {
            // Retrieve the last connected printer URL string from UserDefaults and convert it to URL
            guard let urlString = UserDefaults.standard.string(forKey: "lastConnectedPrinter") else {
                return nil
            }
            return URL(string: urlString)
        }
        set {
            // Convert the URL to a string and save it in UserDefaults
            UserDefaults.standard.set(newValue?.absoluteString, forKey: "lastConnectedPrinter")
        }
    }
}
extension PrinterManager {
    // Function to show an alert using the scene delegate for the active scene
    func showAlertForErrorWithPrinter(_ printerName: String) {
        // Dispatch to the main thread to ensure UI updates are performed safely
        DispatchQueue.main.async {
            let alertTitle = "Printer Error"
            let alertMessage = "Printer \(printerName) is not connected. Something went wrong."
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            
            // Add an "OK" button to dismiss the alert
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Get the active UIWindowScene
            guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
                print("No active window scene found")
                return
            }
            
            // Get the root view controller of the window scene
            guard let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                print("No key window found for the active scene")
                return
            }
            
            // Present the alert
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
