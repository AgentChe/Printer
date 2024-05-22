//
//  Photos.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/14/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import PhotosUI

// Photos
extension MainViewController: PHPickerViewControllerDelegate {

    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                DispatchQueue.main.async {
                    self?.handlePhotoLibraryAuthorizationStatus(status)
                }
            }
        case .restricted, .denied:
            showAlertForPhotoLibraryAccess()
        case .authorized, .limited:
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
            break // This case should not happen since we handle notDetermined case separately
        @unknown default:
            fatalError("Unknown photo library authorization status")
        }
    }

    private func openPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0 // 0 means no limit for selection

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    private func showAlertForPhotoLibraryAccess() {
        let alert = UIAlertController(
            title: NSLocalizedString("Photos.PhotoLibraryAccessDenied.Title", comment: ""),
            message: NSLocalizedString("Photos.PhotoLibraryAccessDenied.Message", comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("Photos.PhotoLibraryAccessDenied.OK", comment: ""), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Photos.PhotoLibraryAccessDenied.Settings", comment: ""), style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        var selectedImages: [UIImage] = []
        let itemProviders = results.map { $0.itemProvider }

        let dispatchGroup = DispatchGroup()

        for itemProvider in itemProviders {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()
                itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        selectedImages.append(image)
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.navigateToPrintOptionsViewController(with: selectedImages)
        }
    }

    private func navigateToPrintOptionsViewController(with images: [UIImage]) {
        let photoRenderer = CustomPhotoPrintPageRenderer()
        photoRenderer.photos = images

        let photoPrintOptionsViewController = PhotoPrintOptionsViewController()
        photoPrintOptionsViewController.imageRenderers = [photoRenderer]
        present(photoPrintOptionsViewController, animated: true, completion: nil)
    }
}
