import UIKit
import SwiftyDropbox

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        //DropboxClientsManager.unlinkClients()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SplashViewController.make()
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let oauthCompletion: DropboxOAuthCompletion = {
            if let authResult = $0 {
                switch authResult {
                case .success:
                    print("Success! User is logged into Dropbox.")
                case .cancel:
                    print("Authorization flow was manually canceled by user!")
                case .error(_, let description):
                    print("Error: \(description)")
                }
            }
        }
        for context in URLContexts {
            if DropboxClientsManager.handleRedirectURL(context.url, includeBackgroundClient: false, completion: oauthCompletion) {
                break
            }
        }
        guard let urlContext = URLContexts.first else { return }
        let url = urlContext.url
        if url.scheme == "db-fuxs23rugn88jl2" {
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
                if let fileURLString = queryItems.first(where: { $0.name == "fileURL" })?.value,
                   let fileURL = URL(string: fileURLString) {
                    // Handle file URL for printing
                    printFile(at: fileURL)
                } else if let fileDataString = queryItems.first(where: { $0.name == "fileData" })?.value,
                          let fileData = Data(base64Encoded: fileDataString) {
                    // Handle file data for printing
                    printData(fileData)
                } else if let text = queryItems.first(where: { $0.name == "text" })?.value {
                    // Handle text for printing
                    printText(text)
                }
            } else {
                print("No query items found in the URL.")
            }
        }
    }

    func printFile(at url: URL) {
        // Use shared container to access the file
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.niiaz.khasanov.group") else {
            print("Failed to get container URL")
            return
        }
        let fileURL = containerURL.appendingPathComponent(url.lastPathComponent)
        
        // Check if the file exists at the URL
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("File does not exist at URL: \(fileURL)")
            return
        }
        
        do {
            // Load the data from the URL
            let imageData = try Data(contentsOf: fileURL)
            
            // Validate the image data
            guard let image = UIImage(data: imageData) else {
                print("Failed to create image from data at URL: \(fileURL)")
                return
            }
            
            // Configure the print interaction controller
            let printController = UIPrintInteractionController.shared
            
            // Create a print info object and set the job name and output type
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = fileURL.lastPathComponent
            printInfo.outputType = .photo
            printController.printInfo = printInfo
            
            // Set the printing item to be the image
            printController.printingItem = image
            
            // Present the print interaction controller
            printController.present(animated: true) { (controller, completed, error) in
                if completed {
                    print("Print completed successfully.")
                } else {
                    if let error = error {
                        print("Failed to print: \(error.localizedDescription)")
                    } else {
                        print("Print was cancelled.")
                    }
                }
            }
            
        } catch {
            print("Error loading data from URL: \(fileURL), error: \(error)")
        }
    }

    func printData(_ data: Data) {
        // Implement data printing logic
        print("Printing data")
        // e.g., present UIPrintInteractionController with the data
    }

    func printText(_ text: String) {
        // Implement text printing logic
        print("Printing text: \(text)")
        // e.g., present UIPrintInteractionController with the text
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called as the scene is about to move from active to inactive state.
        // This can occur due to temporary interruptions (ex: an incoming phone call).
        if let window = window {
            if let tabBarVC = window.rootViewController as? TabBarController {
                if let tabBarVCS = tabBarVC.viewControllers {
                    if let mainVCNavVC = tabBarVCS[0] as? UINavigationController {
                        if let mainViewController = mainVCNavVC.viewControllers.first as? MainViewController {
                            PrinterManager.shared.connectToLastConnectedPrinter { [weak self] printer, error  in
                                if let printer = printer {
                                    print("Reconnected to the last printer: \(printer.displayName)")
                                    mainViewController.delegate?.reloadCollectionView()  // Update the UI as needed
                                    // Here, you could initiate further actions, such as starting a print job
                                } else if let error = error {
                                    if let lastPrinterURL = PrinterManager.shared.lastConnectedPrinter {
                                        let lastPrinterName = PrinterManager.shared.getPrinterName(for: lastPrinterURL)
                                        PrinterManager.shared.showAlertForErrorWithPrinter(lastPrinterName ?? "Unknown", viewController: mainViewController)
                                        PrinterManager.shared.disconnectPrinter()
                                        mainViewController.delegate?.reloadCollectionView()
                                        print("Error: \(error.localizedDescription)")
                                        // Handle error (e.g., show an alert or update UI to reflect the error)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
