//
//  Files.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/14/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import PhotosUI
class CustomDocument: UIDocument {
    var documentData: Data?

    override func contents(forType typeName: String) throws -> Any {
        // Provide the document's data
        return documentData ?? Data()
    }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load the document's data
        if let data = contents as? Data {
            documentData = data
        }
    }
}

// MARK: - File Handling
extension MainViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        print("Selected file URL: \(selectedFileURL)")
        handleSelectedFile(url: selectedFileURL)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
    
    func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf, UTType.text, UTType.image, UTType.item])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    private func handleSelectedFile(url: URL) {
        let document = CustomDocument(fileURL: url)
        document.open { [weak self] success in
            if success {
                self?.printDocument(document: document)
            } else {
                print("Failed to open the document.")
            }
        }
    }
    
    private func printDocument(document: CustomDocument) {
        guard let printer = PrinterManager.shared.getConnectedPrinter() else {
            print("Printer is not configured or unavailable.")
            return
        }
        
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printInfo.jobName = document.fileURL.lastPathComponent
        
        printController.printInfo = printInfo
        printController.printingItem = document.documentData
        
        printController.present(animated: true, completionHandler: nil)
    }
}
