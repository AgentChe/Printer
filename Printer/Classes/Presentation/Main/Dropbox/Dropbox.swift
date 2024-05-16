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
                    let printController = UIPrintInteractionController.shared
                    let printInfo = UIPrintInfo(dictionary: nil)
                    printInfo.outputType = .general
                    printController.printInfo = printInfo
                    printController.printingItem = temporaryFileURL
                    printController.present(animated: true, completionHandler: nil)
                } catch {
                    print(String(format: NSLocalizedString("Dropbox.ErrorWritingFile", comment: ""), error.localizedDescription))
                }
            } else if let error = error {
                print(String(format: NSLocalizedString("Dropbox.ErrorDownloadingFile", comment: ""), error.localizedDescription))
            }
        }
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
