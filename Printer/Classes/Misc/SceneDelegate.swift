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
        
        guard let urlContext = URLContexts.first else {
           
            return
        }
    
        let url = urlContext.url
        if url.scheme == "db-fuxs23rugn88jl2" {
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
                if SessionManager().hasActiveSubscriptions() {
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
 
                    let vc = PaygateViewController.make()
                    if let window = window {
                        if let tabBarVC = window.rootViewController as? TabBarController {
                            if let tabBarVCS = tabBarVC.viewControllers {
                                if let mainVCNavVC = tabBarVCS[0] as? UINavigationController {
                                    if let mainViewController = mainVCNavVC.viewControllers.first as? MainViewController {
                                        mainViewController.present(vc, animated: true)
                                        //do not chack twice
                                        let defaults = UserDefaults(suiteName: GlobalDefinitions.groupId)
                                        if let urlString = defaults?.string(forKey: "sharedURL"), let url = URL(string: urlString) {
                                            defaults?.removeObject(forKey: "sharedURL")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                print("No query items found in the URL.")
            }
        }
    }
     func checkForSavedURL() {
         let defaults = UserDefaults(suiteName: GlobalDefinitions.groupId)
         if let urlString = defaults?.string(forKey: "sharedURL"), let url = URL(string: urlString) {
             defaults?.removeObject(forKey: "sharedURL")
             if SessionManager().hasActiveSubscriptions() {
                 handleIncomingURL(url)
             }  else {
                 let vc = PaygateViewController.make()
                 if let window = window {
                     if let tabBarVC = window.rootViewController as? TabBarController {
                         if let tabBarVCS = tabBarVC.viewControllers {
                             if let mainVCNavVC = tabBarVCS[0] as? UINavigationController {
                                 if let mainViewController = mainVCNavVC.viewControllers.first as? MainViewController {
                                     mainViewController.present(vc, animated: true)
                                 }
                             }
                         }
                     }
                 }
             }
         }
    }

    private func handleIncomingURL(_ url: URL) {
        // Your existing URL handling logic here
        if url.scheme == "db-fuxs23rugn88jl2"  {
           
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
import UIKit

extension SceneDelegate {
    func showAlert(message: String) {
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        if window?.rootViewController == nil {
            let viewController = UIViewController()
            viewController.view.backgroundColor = .white
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
        
        guard let window = window, let rootViewController = window.rootViewController else {
            print("No root view controller found.")
            return
        }
        rootViewController.view.backgroundColor = .white
        var topController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        topController.present(alertController, animated: true, completion: nil)
    }
}
