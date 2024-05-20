import UIKit
import SwiftyDropbox

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

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
                    printFile(at: fileURL)
                } else if let fileDataString = queryItems.first(where: { $0.name == "fileData" })?.value,
                          let fileData = Data(base64Encoded: fileDataString) {
                    printData(fileData)
                } else if let text = queryItems.first(where: { $0.name == "text" })?.value {
                    printText(text)
                }
            } else {
                print("No query items found in the URL.")
            }
        }
    }

    func printFile(at url: URL) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.niiaz.khasanov.group") else {
            print("Failed to get container URL")
            return
        }
        let fileURL = containerURL.appendingPathComponent(url.lastPathComponent)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("File does not exist at URL: \(fileURL)")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let pathExtension = fileURL.pathExtension.lowercased()
            
            switch pathExtension {
            case "pdf":
                printPDF(data: data, fileURL: fileURL)
            case "txt", "swift", "md", "note": // Add more text-based extensions here
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                printText(text)
            case "docx":
                printDocx(data)
            default:
                printImage(data: data, fileURL: fileURL)
            }
            
        } catch {
            print("Error loading data from URL: \(fileURL), error: \(error)")
        }
    }

    func printPDF(data: Data, fileURL: URL) {
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = fileURL.lastPathComponent
        printInfo.outputType = .general
        printController.printInfo = printInfo
        printController.printingItem = data
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
    }

    func printImage(data: Data, fileURL: URL) {
        guard let image = UIImage(data: data) else {
            print("Failed to create image from data at URL: \(fileURL)")
            return
        }
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = fileURL.lastPathComponent
        printInfo.outputType = .photo
        printController.printInfo = printInfo
        printController.printingItem = image
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
    }

    func printData(_ data: Data) {
        // Implement data printing logic
        print("Printing data")
        // e.g., present UIPrintInteractionController with the data
    }

    func printText(_ text: String) {
        let textWithNewCarriageReturns = text.replacingOccurrences(of: "\n", with: "<br />")

        let printController = UIPrintInteractionController.shared

        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printController.printInfo = printInfo

        let format = UIMarkupTextPrintFormatter(markupText: textWithNewCarriageReturns)

        format.perPageContentInsets.top = 72
        format.perPageContentInsets.bottom = 72
        format.perPageContentInsets.left = 72
        format.perPageContentInsets.right = 72
        printController.printFormatter = format

        printController.present(animated: true, completionHandler: nil)
    }
    
    func printDocx(_ data: Data) {
        let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("docx")
        do {
            try data.write(to: tempFileURL)
            let printController = UIPrintInteractionController.shared
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = tempFileURL.lastPathComponent
            printInfo.outputType = .general
            printController.printInfo = printInfo
            printController.printingItem = tempFileURL
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
                try? FileManager.default.removeItem(at: tempFileURL)
            }
        } catch {
            print("Error writing DOCX data to temporary file: \(error.localizedDescription)")
        }
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
                                } else if let error = error {
                                    if let lastPrinterURL = PrinterManager.shared.lastConnectedPrinter {
                                        let lastPrinterName = PrinterManager.shared.getPrinterName(for: lastPrinterURL)
                                        PrinterManager.shared.showAlertForErrorWithPrinter(lastPrinterName ?? "Unknown", viewController: mainViewController)
                                        PrinterManager.shared.disconnectPrinter()
                                        mainViewController.delegate?.reloadCollectionView()
                                        print("Error: \(error.localizedDescription)")
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
