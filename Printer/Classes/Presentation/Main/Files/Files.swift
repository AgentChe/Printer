import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import PhotosUI
import PDFKit

class CustomDocument: UIDocument {
    var documentData: Data?
    var documentType: UTType?

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
        let supportedTypes: [UTType] = [
            .pdf,
            .text,
            .image,
            .item,
            .json,
            .plainText,
            .utf8PlainText,
            UTType(filenameExtension: "swift")!,
            UTType(filenameExtension: "json")!,
            UTType(filenameExtension: "txt")!
        ]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    private func handleSelectedFile(url: URL) {
        let document = CustomDocument(fileURL: url)
        document.open { [weak self] success in
            if success {
                document.documentType = UTType(filenameExtension: url.pathExtension)
                self?.printDocument(document: document)
            } else {
                print("Failed to open the document.")
            }
        }
    }
    
    private func printDocument(document: CustomDocument) {
        guard let documentData = document.documentData,
              let documentType = document.documentType,
              let printer = PrinterManager.shared.getConnectedPrinter() else {
            print("Printer is not configured or unavailable.")
            return
        }
        
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printInfo.jobName = document.fileURL.lastPathComponent
        
        printController.printInfo = printInfo
        
        if documentType.conforms(to: .image), let image = UIImage(data: documentData) {
            printController.printingItem = image
        } else if documentType.conforms(to: .pdf) {
            printController.printingItem = documentData
        } else if let text = String(data: documentData, encoding: .utf8) {
            let pdfData = createPDF(from: text)
            printController.printingItem = pdfData
        } else {
            print("Unsupported document type.")
            return
        }
        
        printController.present(animated: true, completionHandler: nil)
    }
    
    private func createPDF(from text: String) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "My App",
            kCGPDFContextAuthor: "My App"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            
            let textAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
            ]
            let attributedText = NSAttributedString(string: text, attributes: textAttributes)
            
            attributedText.draw(in: pageRect.insetBy(dx: 20, dy: 20))
        }
        
        return data
    }
}
