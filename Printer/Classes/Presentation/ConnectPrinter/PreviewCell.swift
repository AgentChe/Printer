//
//  PreviewCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/13/24.
//

import UIKit
class PreviewCell: UICollectionViewCell {
    static let identifier = "PreviewCellIdentifier"

    // Customize your cell
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(previewImageView)
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: topAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage) {
        previewImageView.image = image
    }
}


 
