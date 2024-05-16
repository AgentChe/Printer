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
                    //  PrinterManager.shared.showAlertForErrorWithPrinter(printerName, viewController: viewController4Alert)
                }
                print("Error: \(error.localizedDescription)")
            }
        }
        title = NSLocalizedString("MainViewController.Title", comment: "")
        
        // Enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Style the navigation bar for iOS 15 and later
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Appearance.mainViewBackground
            appearance.titleTextAttributes = [
                .foregroundColor: Appearance.black,
                .font: Fonts.SFProDisplay.medium(size: 17.scale) // Replace system font with custom font
            ]
            appearance.largeTitleTextAttributes = [
                .foregroundColor: Appearance.black,
                .font: Fonts.SFProDisplay.bold(size: 34.scale) // Replace system font with custom font
            ]
            appearance.shadowColor = nil
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = Appearance.white
            navigationController?.navigationBar.titleTextAttributes = [
                .foregroundColor: Appearance.black,
                .font: Fonts.SFProDisplay.medium(size: 17.scale) // Replace system font with custom font
            ]
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.largeTitleTextAttributes = [
                .foregroundColor: Appearance.black,
                .font: Fonts.SFProDisplay.bold(size: 34.scale) // Replace system font with custom font
            ]
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
        case NSLocalizedString("MainViewController.Action.Photos", comment: ""):
            print("Selected Photos action")
            checkPhotoLibraryPermission()
        case NSLocalizedString("MainViewController.Action.Files", comment: ""):
            print("Selected Files action")
            openDocumentPicker()
        case NSLocalizedString("MainViewController.Action.WebPages", comment: ""):
            print("Selected Web Pages action")
            let webVC = WebViewController()
            webVC.hidesBottomBarWhenPushed = true // Hide the tab bar
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.backBarButtonItem = backButton
            // Hide the toolbar before the transition
            navigationController?.pushViewController(webVC, animated: true)
        case NSLocalizedString("MainViewController.Action.Notes", comment: ""):
            print("Selected Notes action")
            let notesVC = NotesViewController()
            notesVC.modalPresentationStyle = .fullScreen
            notesVC.delegate = self
            present(notesVC, animated: true, completion: nil)
        case NSLocalizedString("MainViewController.Action.GoogleDrive", comment: ""):
            print("Selected Google Drive action")
        case NSLocalizedString("MainViewController.Action.Dropbox", comment: ""):
            print("Selected Dropbox action")
            openDropbox()
        case NSLocalizedString("MainViewController.Action.Email", comment: ""):
            print("Selected Email action")
            let mailVC = MailViewController()
            mailVC.modalPresentationStyle = .fullScreen
            present(mailVC, animated: true, completion: nil)
        case NSLocalizedString("MainViewController.Action.TestPrint", comment: ""):
            print("Selected Test Print action")
            let printTestFileVC = PrintTestFileViewController()
            printTestFileVC.modalPresentationStyle = .fullScreen
            self.present(printTestFileVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func didTapAddPrinter() {
        // Handle add printer action
    }
    
    func didTapCompatibleList() {
        // Handle compatible list action
    }
}

extension MainViewController: NotesViewControllerDelegate {
    func notesViewController(_ controller: NotesViewController, didSaveFormattedText text: NSAttributedString) {
        // Handle the formatted text if needed in MainViewController
    }
}
