//
//  ScannedResultsViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/5/24.
//

import UIKit

class ScannedResultsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let collectionView: UICollectionView = {
        let layout = CenteredFlowLayout()
        layout.itemSize = CGSize(width: 325.scale, height: 459.scale)
        layout.scrollDirection = .horizontal
        let sideInset = (ScreenSize.width.scale - 325.scale) / 2 + layout.minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let printButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Print file", for: .normal)
        button.backgroundColor = Appearance.signatureBlue
        button.layer.cornerRadius = 24
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save to files", for: .normal)
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17)
        button.setTitleColor(Appearance.signatureBlue, for: .normal)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(printButton)
        view.addSubview(saveButton)
        
        setupCollectionView()
        setupButtons()
        setupNavigationBar()
        
        printButton.addTarget(self, action: #selector(printButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabBarVC = findRootTabBarController()
        tabBarVC?.tabBar.isHidden = false
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView.backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: ScreenSize.isIphoneXFamily ? 10.scale : 20.scale),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func setupButtons() {
        printButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: printButton.topAnchor, constant: ScreenSize.isIphoneXFamily ? -10.scale : -20.scale),
            printButton.widthAnchor.constraint(equalToConstant: 358.scale),
            printButton.heightAnchor.constraint(equalToConstant: 68.scale),
            printButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            printButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -105.scale : -50.scale),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -50.scale : 0.scale)
        ])
    }

    private func setupNavigationBar() {
        self.title = "Scan \(formattedCurrentDate())"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }

    private func formattedCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        return dateFormatter.string(from: Date())
    }

    @objc private func shareTapped() {
        var itemsToShare = [Any]()
        for scanResult in ImageManager.shared.imageScans {
            if let image = scanResult.enhancedScan?.image {
                itemsToShare.append(image)
            }
        }
        if itemsToShare.isEmpty {
            showAlert(with: "No Images", message: "There are no images to share.")
            return
        }
        let message = "Sharing \(itemsToShare.count) image\(itemsToShare.count > 1 ? "s" : "")."
        itemsToShare.insert(message, at: 0)
        
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    @objc private func printButtonTapped() {
        let printOptionsVC = PrintOptionsViewController()
        let images = ImageManager.shared.imageScans.compactMap { $0.enhancedScan?.image }
        let imageRenderer = CustomPrintImagePageRenderer()
        imageRenderer.printImages = images
        printOptionsVC.imageRenderers = [imageRenderer]
        present(printOptionsVC, animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        let images = ImageManager.shared.imageScans.compactMap { $0.enhancedScan?.image }
        if images.isEmpty {
            showAlert(with: "No Images", message: "There are no images to save.")
            return
        }
        saveImagesToFiles(images: images)
    }

    private func saveImagesToFiles(images: [UIImage]) {
        var temporaryURLs = [URL]()
        for (index, image) in images.enumerated() {
            if let data = image.jpegData(compressionQuality: 1.0) {
                let temporaryDirectoryURL = FileManager.default.temporaryDirectory
                let fileName = "Image_\(index).jpeg"
                let temporaryURL = temporaryDirectoryURL.appendingPathComponent(fileName)
                do {
                    try data.write(to: temporaryURL)
                    temporaryURLs.append(temporaryURL)
                } catch {
                    print("Error writing image to temporary file: \(error)")
                }
            }
        }

        if !temporaryURLs.isEmpty {
            let documentPicker = UIDocumentPickerViewController(forExporting: temporaryURLs, asCopy: true)
            documentPicker.delegate = self
            present(documentPicker, animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageManager.shared.getImageScansCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        let image = ImageManager.shared.imageScans[indexPath.item].enhancedScan?.image
        cell.imageView.image = image
        cell.collectionView = collectionView
        cell.parentVC = self
        return cell
    }
}

extension ScannedResultsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            print("Saved to: \(url)")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
}

