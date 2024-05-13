//
//  PrintOptionsViewController_v1.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/13/24.
//


import UIKit

class PrintOptionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var options = ["Option 1", "Option 2", "Option 3"] // Example data
    var previews: [UIImage] = [UIImage(named:"PreviewExample")!,UIImage(named:"PreviewExample")!,UIImage(named:"PreviewExample")!]
    private let printOptionsTitle: UILabel = {
        let label = UILabel()
        label.text = "Print Options"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 20
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "Preview"
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let previewCollectionView: UICollectionView = {
        let layout = CenteredFlowLayoutForPreviewsCollectionView()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: (ScreenSize.width - 154)/2, bottom: 0, right:  (ScreenSize.width - 154)/2)
        layout.scrollDirection = .horizontal // Set the scroll direction to horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false // Optional: Hide the horizontal scroll indicator
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OptionCell.self, forCellWithReuseIdentifier: OptionCell.identifier)

        previewCollectionView.delegate = self
        previewCollectionView.dataSource = self
        previewCollectionView.register(PreviewCell.self, forCellWithReuseIdentifier: PreviewCell.identifier)

        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(printOptionsTitle)
        view.addSubview(collectionView)
        view.addSubview(previewLabel)
        view.addSubview(previewCollectionView)

        NSLayoutConstraint.activate([
            printOptionsTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            printOptionsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            printOptionsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            printOptionsTitle.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: printOptionsTitle.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 283)
        ])

        NSLayoutConstraint.activate([
            previewLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            previewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewLabel.widthAnchor.constraint(equalToConstant: 89),
            previewLabel.heightAnchor.constraint(equalToConstant: 29)
        ])

        NSLayoutConstraint.activate([
            previewCollectionView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 20),
            previewCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewCollectionView.heightAnchor.constraint(equalToConstant: 226) // Height for the preview collection view
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return options.count
        } else if collectionView == self.previewCollectionView {
            // Return the count for the preview items
            return previews.count // Assume you have a similar array for previews
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCell.identifier, for: indexPath) as? OptionCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: options[indexPath.row])
            return cell
        } else if collectionView == self.previewCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCell.identifier, for: indexPath) as? PreviewCell else {
                return UICollectionViewCell()
            }
            // Configure the cell with preview-specific data
            cell.configure(with: previews[indexPath.row]) // Assume configuration method
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            print("Selected Option: \(options[indexPath.row])")
        } else if collectionView == self.previewCollectionView {
            print("Selected Preview: \(previews[indexPath.row])") // Log preview selection
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 326, height: indexPath.row == 2 ? 136 : 64) // Sizes for the main options
        } else if collectionView == self.previewCollectionView {
            // Define sizes for the preview collection view items
            return CGSize(width: 154, height: 228) // Example size for all preview cells
        }
        return CGSize.zero
    }
}
