//
//  MainViewController.swift
//  Printer
//
//  Created by Андрей Чернышев on 24.04.2024.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import PhotosUI
import SwiftyDropbox

final class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private lazy var mainView = MainView()
    weak var delegate: ConnectPrinterCellDelegate?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.reloadCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = mainView
        mainView.delegate = self
        
        PrinterManager.shared.connectToLastConnectedPrinter { [weak self] printer, error in
            if let printer = printer {
                print("Reconnected to the last printer: \(printer.displayName)")
                self?.delegate?.reloadCollectionView()  // Update the UI as needed
            } else if let error = error {
                let printerName = printer?.displayName ?? "Unknown"
                if let viewController4Alert = self {
                    PrinterManager.shared.showAlertForErrorWithPrinter(printerName, viewController: viewController4Alert)
                }
                print("Error: \(error.localizedDescription)")
            }
        }
        title = "My printer"
        
        // Enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Style the navigation bar for iOS 15 and later
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Appearance.mainViewBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.shadowColor = nil
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        }
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        viewModel.onQuickActionsChanged = { [weak self] actions in
            self?.mainView.quickActions = actions
            self?.mainView.collectionView.reloadData()
        }
        
        viewModel.onPrinterStatusChanged = { [weak self] status in
            // self?.mainView.updatePrinterStatus(status)
        }
        
        viewModel.loadQuickActions()
        // viewModel.checkPrinterStatus()
    }
}

// MARK: Make
extension MainViewController {
    static func make() -> MainViewController {
        MainViewController()
    }
}

extension MainViewController: MainViewDelegate {
    func didSelectQuickAction(_ action: QuickAction) {
        switch action.title {
        case "Photos":
            print("Selected Photos action")
            checkPhotoLibraryPermission()
        case "Files":
            print("Selected Files action")
            openDocumentPicker()
        case "Web Pages":
            print("Selected Web Pages action")
        case "Notes":
            print("Selected Notes action")
        case "Google Drive":
            print("Selected Google Drive action")
        case "Dropbox":
            print("Selected Dropbox action")
            if DropboxClientsManager.authorizedClient == nil {
                       let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
                       DropboxClientsManager.authorizeFromControllerV2(
                           UIApplication.shared,
                           controller: self,
                           loadingStatusDelegate: nil,
                           openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
                           scopeRequest: scopeRequest
                       )
                   } else {
                       // The user is already authorized, proceed with API calls
                       listDropboxFiles()
                   }
        case "Email":
            print("Selected Email action")
        case "Test Print":
            print("Selected Test Print action")
        default:
            break
        }
    }
    func listDropboxFiles() {
          DropboxClientsManager.authorizedClient?.files.listFolder(path: "").response { response, error in
              if let result = response {
                  for entry in result.entries {
                      print(entry.name)
                  }
              } else if let error = error {
                  print(error)
              }
          }
      }
    func didTapAddPrinter() {
        // Handle add printer action
    }
    
    func didTapCompatibleList() {
        // Handle compatible list action
    }
}

