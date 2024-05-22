import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import PhotosUI
import SwiftyDropbox

extension MainViewController: DropboxFilesViewControllerDelegate {
    func didSelectDropboxFile(_ dropboxFile: Files.Metadata) {
        guard let pathLower = dropboxFile.pathLower else { return }
        downloadAndPrintDropboxFile(at: pathLower, fileName: dropboxFile.name)
    }
    
    private func downloadAndPrintDropboxFile(at path: String, fileName: String) {
        DropboxClientsManager.authorizedClient?.files.download(path: path).response { response, error in
            if let (_, data) = response {
                let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(fileName)
                do {
                    try data.write(to: temporaryFileURL)
                    
                    // Determine the file type
                    let fileType = UTType(filenameExtension: temporaryFileURL.pathExtension)
                    
                    let printController = UIPrintInteractionController.shared
                    let printInfo = UIPrintInfo(dictionary: nil)
                    printInfo.outputType = .general
                    printInfo.jobName = fileName
                    printController.printInfo = printInfo
                    
                    // Handle different file types
                    if fileType?.conforms(to: .image) == true {
                        if let image = UIImage(data: data) {
                            printController.printingItem = image
                        } else {
                            print("Failed to load image.")
                            return
                        }
                    } else if fileType?.conforms(to: .pdf) == true {
                        printController.printingItem = data
                    } else if let text = String(data: data, encoding: .utf8) {
                        let pdfData = self.createPDF(from: text)
                        printController.printingItem = pdfData
                    } else {
                        print("Unsupported document type.")
                        return
                    }
                    
                    printController.present(animated: true, completionHandler: nil)
                } catch {
                    print(String(format: NSLocalizedString("Dropbox.ErrorWritingFile", comment: ""), error.localizedDescription))
                }
            } else if let error = error {
                print(String(format: NSLocalizedString("Dropbox.ErrorDownloadingFile", comment: ""), error.localizedDescription))
            }
        }
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

extension MainViewController {
    func openDropbox() {
        if DropboxClientsManager.authorizedClient == nil {
            let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "files.content.read", "files.metadata.read"], includeGrantedScopes: false)
            DropboxClientsManager.authorizeFromControllerV2(
                UIApplication.shared,
                controller: self,
                loadingStatusDelegate: nil,
                openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
                scopeRequest: scopeRequest
            )
        } else {
            presentDropboxFilesViewController()
        }
    }

    private func presentDropboxFilesViewController() {
        let dropboxFilesVC = DropboxFilesViewController()
        dropboxFilesVC.delegate = self
        let navigationController = UINavigationController(rootViewController: dropboxFilesVC)
        present(navigationController, animated: true, completion: nil)
    }
}
