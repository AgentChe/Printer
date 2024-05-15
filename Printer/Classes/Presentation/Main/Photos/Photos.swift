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
// Photos
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        // Handle the selected image
        print("Selected image: \(selectedImage)")
        navigateToPrintOptionsViewController(with: selectedImage)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("Image picker was cancelled")
    }
    
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
    
    private func navigateToPrintOptionsViewController(with image: UIImage) {
        let imageRenderer = CustomPrintImagePageRenderer()
        imageRenderer.printImage = image
        
        let printOptionsViewController = PrintOptionsViewController()
        printOptionsViewController.imageRenderers = [imageRenderer]
        present(printOptionsViewController, animated: true, completion: nil)
    }
}
