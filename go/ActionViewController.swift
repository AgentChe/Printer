import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("viewDidLoad called")
        
        // Set background color to ensure the view is visible
        view.backgroundColor = .white
        
        // Example function to handle input items
        handleInputItems()
    }

    private func handleInputItems() {
        NSLog("handleInputItems called")
        
        guard let extensionItems = self.extensionContext?.inputItems as? [NSExtensionItem] else {
            NSLog("No extension items")
            return
        }

        for item in extensionItems {
            if let attachments = item.attachments {
                for provider in attachments {
                    if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        handleImage(provider: provider)
                        return
                    } else if provider.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) {
                        handlePDF(provider: provider)
                        return
                    }
                }
            }
        }
        NSLog("No matching item found")
    }

    private func handlePDF(provider: NSItemProvider) {
        provider.loadItem(forTypeIdentifier: UTType.pdf.identifier, options: nil) { (pdfURL, error) in
            NSLog("handlePDF called")
            
            OperationQueue.main.addOperation {
                if let pdfURL = pdfURL as? URL {
                    NSLog("PDF URL: \(pdfURL)")
                    // Set the imageView to an icon or message indicating a PDF was received
                    self.imageView.image = UIImage(systemName: "doc.richtext")
                    self.completeExtension()
                }
            }
        }
    }

    private func handleImage(provider: NSItemProvider) {
        provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (imageURL, error) in
            NSLog("handleImage called")
            
            OperationQueue.main.addOperation {
                if let imageURL = imageURL as? URL {
                    if let image = UIImage(data: try! Data(contentsOf: imageURL)) {
                        self.imageView.image = image
                        self.completeExtension()
                    }
                }
            }
        }
    }

    private func completeExtension() {
        NSLog("completeExtension called")
        
        let url = URL(string: "db-fuxs23rugn88jl2://")!
        
        // Attempt to open the URL to switch to the main app
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                NSLog("UIApplication found, opening URL")
                application.perform(#selector(UIApplication.open(_:options:completionHandler:)), with: url, with: nil)
                break
            }
            responder = responder?.next
        }

        // Complete the request after attempting to open your app
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}
