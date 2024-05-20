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
                    } else if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                        handleText(provider: provider)
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
                        if let savedURL = self.savePDFToSharedContainer(fileURL: url) {
                            self.redirectToApp(with: savedURL)
                        }
                    } else if let data = item as? Data {
                        NSLog("PDF Data loaded")
                        if let savedURL = self.savePDFToSharedContainer(data: data) {
                            self.redirectToApp(with: savedURL)
                        }
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
                        do {
                            let imageData = try Data(contentsOf: url)
                            if let image = UIImage(data: imageData) {
                                self.imageView.image = image
                                if let savedURL = self.saveImageToSharedContainer(image: image) {
                                    self.redirectToApp(with: savedURL)
                                }
                            } else {
                                NSLog("Failed to create image from data at URL: \(url)")
                            }
                        } catch {
                            NSLog("Error loading image data from URL: \(error.localizedDescription)")
                        }
                    } else if let image = item as? UIImage {
                        self.imageView.image = image
                        if let savedURL = self.saveImageToSharedContainer(image: image) {
                            self.redirectToApp(with: savedURL)
                        }
                    } else {
                        NSLog("Unexpected image item type")
                    }
                }
            }
        }
    }
    
    private func handleText(provider: NSItemProvider) {
        NSLog("handleText called")
        if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (item, error) in
                if let error = error {
                    NSLog("Error loading text: \(error.localizedDescription)")
                    return
                }
                
                DispatchQueue.main.async {
                    if let text = item as? String {
                        NSLog("Text: \(text)")
                        if let savedURL = self.saveTextToSharedContainer(text: text) {
                            self.redirectToApp(with: savedURL)
                        }
                    } else {
                        NSLog("Unexpected text item type")
                    }
                }
            }
        }
    }

    private func redirectToApp(with fileURL: URL) {
        var components = URLComponents(string: "db-fuxs23rugn88jl2://")
        components?.queryItems = [
            URLQueryItem(name: "fileURL", value: fileURL.absoluteString)
        ]
        
        guard let url = components?.url else {
            NSLog("Failed to construct URL")
            return
        }

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

    private func saveImageToSharedContainer(image: UIImage) -> URL? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.niiaz.khasanov.group") else {
            NSLog("Failed to get container URL")
            return nil
        }
        let fileName = UUID().uuidString + ".png"
        let fileURL = containerURL.appendingPathComponent(fileName)

        do {
            if let data = image.pngData() {
                try data.write(to: fileURL)
                NSLog("Image saved to shared container: \(fileURL)")
                return fileURL
            } else {
                NSLog("Failed to generate PNG data from image")
            }
        } catch {
            NSLog("Error saving image: \(error.localizedDescription)")
        }
        return nil
    }

    private func savePDFToSharedContainer(fileURL: URL? = nil, data: Data? = nil) -> URL? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.niiaz.khasanov.group") else {
            NSLog("Failed to get container URL")
            return nil
        }
        let fileName = UUID().uuidString + ".pdf"
        let destinationURL = containerURL.appendingPathComponent(fileName)

        do {
            if let fileURL = fileURL {
                try FileManager.default.copyItem(at: fileURL, to: destinationURL)
                NSLog("PDF file saved to shared container: \(destinationURL)")
                return destinationURL
            } else if let data = data {
                try data.write(to: destinationURL)
                NSLog("PDF data saved to shared container: \(destinationURL)")
                return destinationURL
            }
        } catch {
            NSLog("Error saving PDF: \(error.localizedDescription)")
        }
        return nil
    }

    private func saveTextToSharedContainer(text: String) -> URL? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.niiaz.khasanov.group") else {
            NSLog("Failed to get container URL")
            return nil
        }
        let fileName = UUID().uuidString + ".txt"
        let fileURL = containerURL.appendingPathComponent(fileName)

        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            NSLog("Text saved to shared container: \(fileURL)")
            return fileURL
        } catch {
            NSLog("Error saving text: \(error.localizedDescription)")
        }
        return nil
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
          //  self.completeExtension()
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
