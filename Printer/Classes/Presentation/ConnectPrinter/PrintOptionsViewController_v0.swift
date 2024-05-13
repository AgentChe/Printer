//
//  PrintOptionsViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/12/24.
//

import UIKit


class PrintOptionsViewController_v0: UIViewController {
    // UI Components
    let layout = UICollectionViewFlowLayout()
    
    let printerLabel = UILabel()
    let copyLabel = UILabel()
    let pagesPerSheetLabel = UILabel()
    let printerValueLabel = UILabel()
    let copyStepper = UIStepper()
    let copyValueLabel = UILabel()
    var pagesPerSheetCollectionView: UICollectionView!
    
    // Data Source for Collection View
    let pagesOptions = [1, 2, 4, 6, 9, 16]
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupLabels()
        setupStepper()
        layoutUI()
    }
    
    func setupLabels() {
        // Setup the text, fonts, and other properties for labels
        printerLabel.text = "Printer"
        copyLabel.text = "Copy"
        pagesPerSheetLabel.text = "Pages per sheet"
        
        printerValueLabel.text = "not selected"
        copyValueLabel.text = "1"
        
        // Add all labels to the view
        view.addSubview(printerLabel)
        view.addSubview(copyLabel)
        view.addSubview(pagesPerSheetLabel)
        view.addSubview(printerValueLabel)
        view.addSubview(copyValueLabel)
        view.addSubview(copyStepper)
        view.addSubview(pagesPerSheetCollectionView)
    }
    
    func setupStepper() {
        copyStepper.minimumValue = 1
        copyStepper.maximumValue = 99
        copyStepper.value = 1
        copyStepper.addTarget(self, action: #selector(copyStepperChanged), for: .valueChanged)
        view.addSubview(copyStepper)
    }
    
    @objc func copyStepperChanged() {
        let stepperValue = Int(copyStepper.value)
        copyValueLabel.text = "\(stepperValue)"
    }
    
    func setupCollectionView() {
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 44.scale, height: 68.scale)  // Adjust the cell size as needed
        layout.minimumInteritemSpacing = 15.scale  // Set minimum spacing between cells, adjust as needed
        layout.minimumLineSpacing = 15.scale
        pagesPerSheetCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        pagesPerSheetCollectionView.backgroundColor = .clear
        pagesPerSheetCollectionView.allowsMultipleSelection = false
        pagesPerSheetCollectionView.register(PagesPerSheetCell_v0.self, forCellWithReuseIdentifier: "PagesPerSheetCell")
        pagesPerSheetCollectionView.delegate = self
        pagesPerSheetCollectionView.dataSource = self
        
        view.addSubview(pagesPerSheetCollectionView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let totalCellWidth = pagesOptions.count * Int(layout.itemSize.width) + (pagesOptions.count - 1) * Int(layout.minimumInteritemSpacing)
        let padding = (pagesPerSheetCollectionView.bounds.width - CGFloat(totalCellWidth)) / 2.0
        let inset = max(padding, 20.0)  // Ensure there's at least some minimum padding, adjust as needed

        // Correctly applying padding as inset
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        pagesPerSheetCollectionView.collectionViewLayout = layout
    }
    func layoutUI() {
        // Disabling autoresizing mask translation and setting up constraints
        [printerLabel, printerValueLabel, copyLabel, copyValueLabel, copyStepper, pagesPerSheetLabel, pagesPerSheetCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Printer label and value
        NSLayoutConstraint.activate([
            printerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.scale),
            printerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.scale),
            printerValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.scale),
            printerValueLabel.centerYAnchor.constraint(equalTo: printerLabel.centerYAnchor),
            printerValueLabel.leadingAnchor.constraint(equalTo: printerLabel.trailingAnchor, constant: 8.scale)
        ])
        
        // Copy label, stepper, and value label
        NSLayoutConstraint.activate([
            copyLabel.topAnchor.constraint(equalTo: printerLabel.bottomAnchor, constant: 40.scale),
            copyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.scale),
            copyStepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.scale),
            copyStepper.centerYAnchor.constraint(equalTo: copyLabel.centerYAnchor),
            copyValueLabel.trailingAnchor.constraint(equalTo: copyStepper.leadingAnchor, constant: -10.scale),
            copyValueLabel.centerYAnchor.constraint(equalTo: copyLabel.centerYAnchor)
        ])
        
        // Pages per sheet
        NSLayoutConstraint.activate([
            pagesPerSheetLabel.topAnchor.constraint(equalTo: copyLabel.bottomAnchor, constant: 40.scale),
            pagesPerSheetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.scale),
            pagesPerSheetCollectionView.topAnchor.constraint(equalTo: pagesPerSheetLabel.bottomAnchor, constant: 20.scale),
            pagesPerSheetCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.scale),
            pagesPerSheetCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:0.scale),
            pagesPerSheetCollectionView.heightAnchor.constraint(equalToConstant: 70.scale)  // Assuming each item's height is 60
        ])
    }
}

extension PrintOptionsViewController_v0: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagesOptions.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           // Iterate through all cells and update their selected state
           for cell in collectionView.visibleCells {
               if let customCell = cell as? PagesPerSheetCell_v0 {
                   customCell.isSelected = false  // Deselect all cells
               }
           }
           // Select the tapped cell
           if let cell = collectionView.cellForItem(at: indexPath) as? PagesPerSheetCell_v0 {
               cell.isSelected = true
           }
       }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PagesPerSheetCell_v0 {
            cell.isSelected = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PagesPerSheetCell", for: indexPath) as? PagesPerSheetCell_v0 else {
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
