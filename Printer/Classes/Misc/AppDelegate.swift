//
//  AppDelegate.swift
//  Soccer
//
//  Created by Андрей Чернышев on 13.09.2022.
//

import UIKit
import OtterScaleiOS
import SwiftyDropbox

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NumberLaunches().launch()
        
        FacebookManager.shared.initialize(app: application, launchOptions: launchOptions)
        FirebaseManager.shared.initialize()
        OtterScale.shared.initialize(host: GlobalDefinitions.otterScaleHost, apiKey: GlobalDefinitions.otterScaleApiKey)
        
        PurchaseValidationObserver.shared.startObserve()
        DropboxClientsManager.setupWithAppKey("fuxs23rugn88jl2")
        IAPManager.initialize()
        
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       
        FacebookManager.shared.application(app, open: url, options: options)
        let oauthCompletion: DropboxOAuthCompletion = { authResult in
            if let authResult = authResult {
                switch authResult {
                case .success:
                    print("Success! User is logged into Dropbox.")
                case .cancel:
                    print("Authorization flow was manually canceled by user!")
                case .error(_, let description):
                    print("Error: \(String(describing: description))")
                }
            }
        }
        
        let canHandleUrl = DropboxClientsManager.handleRedirectURL(
            url,
            backgroundSessionIdentifier: "com.yourapp.backgroundSession",
            completion: oauthCompletion
        )
        if url.scheme == "db-fuxs23rugn88jl2" {
            // Navigate to specific view controller or perform action
            print("App was opened via URL scheme!")
        }
        
        
        return true
    }
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        DropboxClientsManager.handleEventsForBackgroundURLSession(
            with: identifier,
            creationInfos: [],
            completionHandler: completionHandler,
            requestsToReconnect: { requestResults in
                // Handle reconnection if needed
                self.processReconnect(requestResults: requestResults)
            }
        )
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushNotificationsManager.shared.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PushNotificationsManager.shared.application(didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PushNotificationsManager.shared.application(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
    
    private func processReconnect(requestResults: [Result<DropboxBaseRequestBox, ReconnectionError>]) {
        let successfulRequests = requestResults.compactMap { result -> DropboxBaseRequestBox? in
            switch result {
            case .success(let requestBox):
                return requestBox
            case .failure(let error):
                print("Reconnection error: \(error)")
                return nil
            }
        }
        
        for request in successfulRequests {
            switch request {
            case .download(let downloadRequest):
                downloadRequest.response { response, error in
                    if let response = response {
                        print("Download success: \(response)")
                    } else if let error = error {
                        print("Download error: \(error)")
                    }
                }
            case .upload(let uploadRequest):
                uploadRequest.response { response, error in
                    if let response = response {
                        print("Upload success: \(response)")
                    } else if let error = error {
                        print("Upload error: \(error)")
                    }
                }
                // Handle other request types if necessary
            default:
                break
            }
        }
    }
}

extension AppDelegate {
    func showAlert(message: String) {
        guard let window = getActiveWindow(), let rootViewController = window.rootViewController else {
            print("No root view controller found.")
            return
        }
        
        var topController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        topController.present(alertController, animated: true, completion: nil)
    }
    // Helper method to get the current active window
    private func getActiveWindow() -> UIWindow? {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            return windowScene.windows.first { $0.isKeyWindow }
        }
        return nil
    }
}
