//
//  ScanViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/3/24.
//
import UIKit
import VisionKit

class ScanViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupDocumentScannerButton()
    }

    private func setupNavigationBar() {
        guard let navigationController = self.navigationController else { return }

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController.navigationBar.standardAppearance = navBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController.navigationBar.compactAppearance = navBarAppearance
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.shadowImage = UIImage()
        
        // Setup buttons for navigation bar if needed
    }
   
    private func setupDocumentScannerButton() {
        let scanDocumentButton = UIButton(type: .system)
        scanDocumentButton.setTitle("Scan Document", for: .normal)
        scanDocumentButton.addTarget(self, action: #selector(presentDocumentScanner), for: .touchUpInside)

        scanDocumentButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanDocumentButton)
        
        NSLayoutConstraint.activate([
            scanDocumentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanDocumentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func presentDocumentScanner() {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }

    // MARK: VNDocumentCameraViewControllerDelegate Methods
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        // Handle the scan result
        for pageIndex in 0..<scan.pageCount {
            let image = scan.imageOfPage(at: pageIndex)
            displayCapturedPhoto(capturedImage: image)
        }
        controller.dismiss(animated: true)
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("Document scanning failed with error: \(error)")
        controller.dismiss(animated: true)
    }
    
    private func displayCapturedPhoto(capturedImage: UIImage) {
        let photoReviewController = PhotoReviewViewController()
        photoReviewController.capturedImage = capturedImage
        photoReviewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(photoReviewController, animated: true)
    }
}
