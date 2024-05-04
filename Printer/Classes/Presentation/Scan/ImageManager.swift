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

    var images: [UIImage] = []

    func addImage(_ image: UIImage) {
        images.append(image)
    }

    func clearImages() {
        images.removeAll()
    }
    func removeLastImage() {
        if !images.isEmpty {
            images.removeLast()
        }
    }
}
