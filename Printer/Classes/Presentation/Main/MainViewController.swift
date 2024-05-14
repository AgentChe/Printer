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
        // Set the title of the navigation item
        PrinterManager.shared.connectToLastConnectedPrinter { [weak self] printer, error in
            if let printer = printer {
                print("Reconnected to the last printer: \(printer.displayName)")
                self?.delegate?.reloadCollectionView()  // Update the UI as needed
                // Here, you could initiate further actions, such as starting a print job
                
            } else if let error = error {
                // Retrieve the display name for the printer or use "Unknown" if not available
                let printerName = printer?.displayName ?? "Unknown"
                if let viewController4Alert = self {
                    PrinterManager.shared.showAlertForErrorWithPrinter(printerName, viewController: viewController4Alert)
                }
                print("Error: \(error.localizedDescription)")
                // Handle error (e.g., show an alert or update UI to reflect the error)
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
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // Large title color
            appearance.shadowColor = nil
            
            // Set the appearance for when the view controller is shown
            navigationController?.navigationBar.standardAppearance = appearance
            // Set the appearance for when the view controller is scrolled
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            // Style the navigation bar for earlier iOS versions
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // Large title color
        }
        // Remove the shadow line for all versions
        navigationController?.navigationBar.shadowImage = UIImage()
        // Set the navigation bar's background image to a blank/empty image
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        
        
        viewModel.onQuickActionsChanged = { [weak self] actions in
            self?.mainView.quickActions = actions
            self?.mainView.collectionView.reloadData()
        }
        
        viewModel.onPrinterStatusChanged = { [weak self] status in
            //   self?.mainView.updatePrinterStatus(status)
        }
        
        viewModel.loadQuickActions()
        //  viewModel.checkPrinterStatus()
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
            // Handle Photos quick action
            print("Selected Photos action")
            openPhotoLibrary()
        case "Files":
            // Handle Files quick action
            print("Selected Files action")
            openDocumentPicker()
        case "Web Pages":
            // Handle Web Pages quick action
            print("Selected Web Pages action")
        case "Notes":
            // Handle Notes quick action
            print("Selected Notes action")
        case "Google Drive":
            // Handle Google Drive quick action
            print("Selected Google Drive action")
        case "Dropbox":
            // Handle Dropbox quick action
            print("Selected Dropbox action")
        case "Email":
            // Handle Email quick action
            print("Selected Email action")
        case "Test Print":
            // Handle Test Print quick action
            print("Selected Test Print action")
        default:
            break
        }
    }
    private func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf, UTType.text, UTType.image, UTType.item])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                DispatchQueue.main.async {
                    self?.handlePhotoLibraryAuthorizationStatus(status)
                }
            }
        case .restricted, .denied:
            // Handle restricted or denied status
            showAlertForPhotoLibraryAccess()
        case .authorized, .limited:
            // Handle authorized or limited status
            openPhotoLibrary()
        @unknown default:
            fatalError("Unknown photo library authorization status")
        }
    }

    private func handlePhotoLibraryAuthorizationStatus(_ status: PHAuthorizationStatus) {
        switch status {
        case .authorized, .limited:
            openPhotoLibrary()
        case .restricted, .denied:
            showAlertForPhotoLibraryAccess()
        case .notDetermined:
            // This case should not happen since we handle notDetermined case separately
            break
        @unknown default:
            fatalError("Unknown photo library authorization status")
        }
    }

    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [UTType.image.identifier]
        present(imagePicker, animated: true, completion: nil)
    }

    private func showAlertForPhotoLibraryAccess() {
        let alert = UIAlertController(title: "Photo Library Access Denied",
                                      message: "Please enable access to the photo library in the Settings app to select photos.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    func didTapAddPrinter() {
        // Handle add printer action
    }
    
    func didTapCompatibleList() {
        // Handle compatible list action
    }
}
//Files
extension MainViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        // Handle the selected file URL
        print("Selected file URL: \(selectedFileURL)")
        // Add your code to handle the file (e.g., print the file)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
}
//Photos
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        // Handle the selected image
        print("Selected image: \(selectedImage)")
        // Add your code to handle the image (e.g., print the image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("Image picker was cancelled")
    }
}
