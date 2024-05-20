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
        
        // Handle input items
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
                    } else if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                        handleURL(provider: provider)
                        return
                    } else {
                        NSLog("No matching type found for attachment: \(provider.registeredTypeIdentifiers)")
                    }
                }
            }
        }
        NSLog("No matching item found")
    }

    private func handlePDF(provider: NSItemProvider) {
        NSLog("handlePDF called")
        if provider.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.pdf.identifier, options: nil) { (item, error) in
                if let error = error {
                    NSLog("Error loading PDF: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    if let url = item as? URL {
                        NSLog("PDF URL: \(url.absoluteString)")
                        self.imageView.image = UIImage(systemName: "doc.richtext")
                        self.completeExtension()
                    } else if let data = item as? Data {
                        NSLog("PDF Data loaded")
                        self.completeExtension()
                    } else {
                        NSLog("Unexpected PDF item type")
                    }
                }
            }
        }
    }

    private func handleImage(provider: NSItemProvider) {
        NSLog("handleImage called")
        if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (item, error) in
                if let error = error {
                    NSLog("Error loading image: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    if let url = item as? URL {
                        NSLog("Image URL: \(url)")
                        if let image = UIImage(data: try! Data(contentsOf: url)) {
                            self.imageView.image = image
                            self.completeExtension()
                        }
                    } else if let image = item as? UIImage {
                        self.imageView.image = image
                        self.completeExtension()
                    } else {
                        NSLog("Unexpected image item type")
                    }
                }
            }
        }
    }

    private func handleURL(provider: NSItemProvider) {
        NSLog("handleURL called")
        if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { (item, error) in
                if let error = error {
                    NSLog("Error loading URL: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    if let url = item as? URL {
                        NSLog("URL: \(url.absoluteString)")
                        self.handleURLContent(url: url)
                    } else {
                        NSLog("Unexpected URL item type")
                    }
                }
            }
        }
    }

    private func handleURLContent(url: URL) {
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            NSLog("URL points to image")
            self.imageView.image = image
            self.completeExtension()
        } else {
            NSLog("URL does not point to image data")
            // Handle other types of URL content if necessary
            self.completeExtension()
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
