//  ImageCollectionViewCell.swift
//  Printer

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var deleteButton: UIButton!
    weak var collectionView: UICollectionView?  // Add a weak reference to the parent collection view
    weak var parentVC: ScannedResultsViewController?  // Add a weak reference to the parent view controller

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupDeleteButton()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    private func setupImageView() {
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
    }

    private func setupDeleteButton() {
        deleteButton = UIButton(type: .custom)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = Appearance.signatureBlue
        deleteButton.backgroundColor = .white
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addSubview(deleteButton)
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Constraints for imageView
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            // Constraints for deleteButton
            deleteButton.widthAnchor.constraint(equalToConstant: 24.scale),
            deleteButton.heightAnchor.constraint(equalToConstant: 24.scale),
            deleteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8.scale),
            deleteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12.scale)
        ])

        deleteButton.layer.cornerRadius = 5.scale  // 1/4th of 24
    }

    @objc private func deleteButtonTapped() {
        guard let collectionView = collectionView,
              let indexPath = collectionView.indexPath(for: self) else { return }
        
        // Remove the scan from the data manager
        ImageManager.shared.removeImageScan(at: indexPath.item)

        // Perform the batch update
        collectionView.performBatchUpdates({
            // Delete the items from the collection view
            collectionView.deleteItems(at: [indexPath])
        }, completion: { _ in
            // Reload data might be necessary if your indices could become out of sync
            collectionView.reloadData()
        })

        delay(0.1) { [weak self] in
            if ImageManager.shared.imageScans.count == 0 {
                self?.parentVC?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

/// Executes the closure after a certain delay.
/// - Parameters:
///   - delay: The delay in seconds before the closure should be executed.
///   - closure: The closure to execute after the delay.
func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}
