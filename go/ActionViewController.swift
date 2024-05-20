import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Get the item[s] we're handling from the extension context.
        handleInputItems()
    }

    private func handleInputItems() {
        guard let extensionItems = self.extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }
        
        for item in extensionItems {
            if let attachments = item.attachments {
                for provider in attachments {
                    if provider.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) {
                        handlePDF(provider: provider)
                        return
                    } else if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        handleImage(provider: provider)
                        return
                    } else if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                        handleText(provider: provider)
                        return
                    }
                }
            }
        }
    }

    private func handlePDF(provider: NSItemProvider) {
        provider.loadItem(forTypeIdentifier: UTType.pdf.identifier, options: nil) { (item, error) in
            if let url = item as? URL {
                self.savePDF(pdfURL: url)
            } else if let data = item as? Data {
                self.savePDF(data: data)
            }
        }
    }

    private func handleImage(provider: NSItemProvider) {
        provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (imageURL, error) in
            OperationQueue.main.addOperation {
                if let imageURL = imageURL as? URL {
                    self.imageView.image = UIImage(data: try! Data(contentsOf: imageURL))
                }
            }
        }
    }

    private func handleText(provider: NSItemProvider) {
        provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (text, error) in
            OperationQueue.main.addOperation {
                if let text = text as? String {
                    print("Text: \(text)")
                }
            }
        }
    }

    private func savePDF(pdfURL: URL) {
        let fileManager = FileManager.default
        let sharedContainerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.yourapp.shared")
        let destinationURL = sharedContainerURL?.appendingPathComponent(pdfURL.lastPathComponent)
        
        do {
            if let destinationURL = destinationURL {
                try fileManager.copyItem(at: pdfURL, to: destinationURL)
                print("PDF saved to \(destinationURL.path)")
            }
        } catch {
            print("Failed to save PDF: \(error)")
        }
    }
    
    private func savePDF(data: Data) {
        let fileManager = FileManager.default
        let sharedContainerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.yourapp.shared")
        let fileName = UUID().uuidString + ".pdf"
        let destinationURL = sharedContainerURL?.appendingPathComponent(fileName)
        
        do {
            if let destinationURL = destinationURL {
                try data.write(to: destinationURL)
                print("PDF saved to \(destinationURL.path)")
            }
        } catch {
            print("Failed to save PDF: \(error)")
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}
