//
//  ConnectPrinterViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/9/24.
//

import UIKit
protocol StatusChangeDelegate: AnyObject {
    func changeWIFIToOn()
    func changeWIFIToOff()
    func changeBTHToOn()
    func changeBTHToOff()
}



class ConnectPrinterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Appearance.mainViewBackground
        
        // Register cell types
        collectionView.register(ConnectPrinterCell.self, forCellWithReuseIdentifier: ConnectPrinterCell.connectPrinterCellKey)
        collectionView.register(AvaliablePrintersCell.self, forCellWithReuseIdentifier: AvaliablePrintersCell.availablePrintersCellKey)
        
        self.view.addSubview(collectionView)
        
        // Set constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    // MARK: UICollectionViewDelegateFlowLayout methods
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if indexPath.item % 2 == 0 {
               return CGSize(width: collectionView.bounds.width, height: 630.scale)
           } else {
               return CGSize(width: collectionView.bounds.width, height: 500.scale)
           }
       }

    // MARK: UICollectionViewDataSource methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 // Adjust based on your data
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Determine which cell to use based on the item index
        if indexPath.item % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConnectPrinterCell.connectPrinterCellKey, for: indexPath) as! ConnectPrinterCell
            // Configure cell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvaliablePrintersCell.availablePrintersCellKey, for: indexPath) as! AvaliablePrintersCell
            // Configure cell
            return cell
        }
    }
}

