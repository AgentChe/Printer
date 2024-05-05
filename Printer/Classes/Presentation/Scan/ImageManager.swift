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
}
