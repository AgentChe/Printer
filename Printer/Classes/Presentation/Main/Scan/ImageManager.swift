//
//  ImageManager.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/4/24.
//

import UIKit
class ImageManager {
    static let shared = ImageManager()
    private init() {} // Private initialization to ensure just one instance is created.

    var imageScans: [ImageScannerResults] = []

    func addImageScans(_ image: ImageScannerResults) {
        imageScans.append(image)
    }

    func clearImages() {
        imageScans.removeAll()
    }

    func removeLastImage() {
        if !imageScans.isEmpty {
            imageScans.removeLast()
        }
    }

    func getImageScansCount() -> Int {
        return imageScans.count
    }

    // Method to remove an image scan at a specified index
    func removeImageScan(at index: Int) {
        if index >= 0 && index < imageScans.count {
            imageScans.remove(at: index)
        } else {
            print("Index out of range")
        }
    }
}
