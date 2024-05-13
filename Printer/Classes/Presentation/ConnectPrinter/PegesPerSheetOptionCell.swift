//
//  PegesPerSheetOptionCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/13/24.
//

import UIKit
class PegesPerSheetOptionCell: UICollectionViewCell {
    static let identifier = "PagesPerSheetOptionCell"
    
    // UI Components
    let layout = UICollectionViewFlowLayout()
    let pagesPerSheetLabel = UILabel()
    var pagesPerSheetCollectionView: UICollectionView!
    
    // Data Source for Collection View
    let pagesOptions = [1, 2, 4, 6, 9, 16]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupLabels()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabels() {
        // Set up the 'Pages per sheet' label
        pagesPerSheetLabel.text = "Pages per sheet"
        pagesPerSheetLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)  // SF Pro weight 590 is close to UIFontWeightSemibold
        pagesPerSheetLabel.textAlignment = .left
        pagesPerSheetLabel.textColor = .black  // Assuming a black color for visibility
        pagesPerSheetLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pagesPerSheetLabel)
    }
    
    func setupCollectionView() {
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 44.scale, height: 68.scale)  // Adjust the cell size as needed
        layout.minimumInteritemSpacing = 15.scale  // Set minimum spacing between cells, adjust as needed
        layout.minimumLineSpacing = 15.scale
        
        pagesPerSheetCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        pagesPerSheetCollectionView.backgroundColor = .clear
        pagesPerSheetCollectionView.allowsMultipleSelection = false
        pagesPerSheetCollectionView.register(PagesPerSheetCell.self, forCellWithReuseIdentifier: "PagesPerSheetCell")
        pagesPerSheetCollectionView.delegate = self
        pagesPerSheetCollectionView.dataSource = self
        
        addSubview(pagesPerSheetCollectionView)
    }
    
    func layoutUI() {
        // Disabling autoresizing mask translation and setting up constraints
        pagesPerSheetLabel.translatesAutoresizingMaskIntoConstraints = false
        pagesPerSheetCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Pages per sheet label constraints
            pagesPerSheetLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.scale),
            pagesPerSheetLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            pagesPerSheetLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            pagesPerSheetLabel.heightAnchor.constraint(equalToConstant: 20.scale),
            
            // Collection view constraints updated to be below the label
            pagesPerSheetCollectionView.topAnchor.constraint(equalTo: pagesPerSheetLabel.bottomAnchor, constant: 20.scale),
            pagesPerSheetCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pagesPerSheetCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pagesPerSheetCollectionView.heightAnchor.constraint(equalToConstant: 70.scale)
        ])
    }
}

extension PegesPerSheetOptionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagesOptions.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Iterate through all cells and update their selected state
        for cell in collectionView.visibleCells {
            if let customCell = cell as? PagesPerSheetCell {
                customCell.isSelected = false  // Deselect all cells
            }
        }
        // Select the tapped cell
        if let cell = collectionView.cellForItem(at: indexPath) as? PagesPerSheetCell {
            cell.isSelected = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PagesPerSheetCell {
            cell.isSelected = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PagesPerSheetCell", for: indexPath) as? PagesPerSheetCell else {
            return UICollectionViewCell()
        }
        
        switch indexPath.item {
        case 0:
            cell.label.text = "1"
            cell.imageView.image = UIImage(named: "PagesPerSheet.1")
        case 1:
            cell.label.text = "2"
            cell.imageView.image = UIImage(named: "PagesPerSheet.2")
        case 2:
            cell.label.text = "4"
            cell.imageView.image = UIImage(named: "PagesPerSheet.4")
        case 3:
            cell.label.text = "6"
            cell.imageView.image = UIImage(named: "PagesPerSheet.6")
        case 4:
            cell.label.text = "9"
            cell.imageView.image = UIImage(named: "PagesPerSheet.9")
        case 5:
            cell.label.text = "16"
            cell.imageView.image = UIImage(named: "PagesPerSheet.16")
        default:
            fatalError()
        }
        
        return cell
    }
}



