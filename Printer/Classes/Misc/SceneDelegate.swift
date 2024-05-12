//
//  SceneDelegate.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.09.2022.
//

import UIKit

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
