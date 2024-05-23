//
//  ScanViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/3/24.
//

import UIKit
import AVFoundation


class ScanViewController: UIViewController, ImageScannerControllerDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the scanner
        let scanner = ImageScannerController()
        scanner.imageScannerDelegate = self
        
        // Add the scanner as a child view controller
        addChild(scanner)
        scanner.view.frame = view.bounds  // Adjust the frame as needed
        view.addSubview(scanner.view)
        scanner.didMove(toParent: self)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        // Handle error
        print(error)
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // Handle cancellation
        scanner.willMove(toParent: nil)
        scanner.view.removeFromSuperview()
        scanner.removeFromParent()
    }

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // Use the scanned image
        scanner.willMove(toParent: nil)
        scanner.view.removeFromSuperview()
        scanner.removeFromParent()
    }
}
