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
        let sideInset = ((ScreenSize.width - 325)/2).scale
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
        //collectionView.isPagingEnabled = true
        //collectionView.decelerationRate = .fast
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView.backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor,constant: ScreenSize.isIphoneXFamily ? 10.scale : 20.scale),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func setupButtons() {
        printButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: printButton.topAnchor, constant:ScreenSize.isIphoneXFamily ? -10.scale:-20.scale),
            printButton.widthAnchor.constraint(equalToConstant: 358.scale),
            printButton.heightAnchor.constraint(equalToConstant: 68.scale),
            printButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            printButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -15.scale:0.scale),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:ScreenSize.isIphoneXFamily ? 45.scale:50.scale)
        ])
    }
    
    private func setupNavigationBar() {
        self.title = "Scan \(formattedCurrentDate())"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    private func formattedCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy" // You can change this to "MM-dd-yyyy", etc., based on your preference.
        return dateFormatter.string(from: Date())
    }
    @objc private func shareTapped() {
        // Implement sharing functionality
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageManager.shared.getImageScansCount() // Number of items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        let image = ImageManager.shared.imageScans[indexPath.item].enhancedScan?.image
        cell.imageView.image = image
        cell.collectionView = collectionView
        cell.parentVC = self
        return cell
    }}
 
