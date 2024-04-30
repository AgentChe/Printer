//
//  MainView.swift
//  Printer
//
//  Created by Андрей Чернышев on 24.04.2024.
//

import UIKit
struct PrinterStatus {
    let isConnected: Bool
    let name: String?
}
protocol MainViewDelegate: AnyObject {
    func didSelectQuickAction(_ action: QuickAction)
    func didTapAddPrinter()
    func didTapCompatibleList()
}

final class MainView: UIView {
    weak var delegate: MainViewDelegate?
    var quickActions: [QuickAction] = []
    var isAnimatingNavigationBar: Bool = false
  
    // Здесь инициализация UICollectionView, как было показано ранее
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100) // Пример размера ячейки
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(QuickActionCell.self, forCellWithReuseIdentifier: QuickActionCell.identifier)
        cv.register(PrinterStatusCell.self, forCellWithReuseIdentifier: PrinterStatusCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        return cv
    }()
    // MARK: - Initializers
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
  
    fileprivate func setupViews() {
        backgroundColor = Appearance.mainViewBackground
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        
        // Collection view constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0.scale),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
//    func updatePrinterStatus(_ status: PrinterStatus?) {
//        if let printerStatus = status, printerStatus.isConnected {
//            // Обновляем изображение и текст для подключенного принтера
//            printerImageView.image = UIImage(named: "connectedPrinterImage") // имя картинки подключенного принтера
//            titleLabel.text = "My printer"
//            subtitleLabel.text = "Printer \(printerStatus.name ?? "") is connected"
//            addPrinterButton.isHidden = true
//            compatibleListButton.isHidden = true
//        } else {
//            // Обновляем изображение и текст для состояния без принтера
//            printerImageView.image = UIImage(named: "defaultPrinterImage") // имя картинки по умолчанию
//            titleLabel.text = "My printer"
//            subtitleLabel.text = "No printer was added"
//            addPrinterButton.isHidden = false
//            compatibleListButton.isHidden = false
//        }
//    }
}

// MARK: - UICollectionViewDataSource
extension MainView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // Two sections: Printer Status and Quick Actions
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : quickActions.count // One Printer Status cell, and dynamic count for Quick Actions
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrinterStatusCell.identifier, for: indexPath) as? PrinterStatusCell else {
                fatalError("Could not dequeue PrinterStatusCell")
            }
            // Configure the cell with printer status
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickActionCell.identifier, for: indexPath) as? QuickActionCell else {
                fatalError("Could not dequeue QuickActionCell")
            }
            let action = quickActions[indexPath.row]
            cell.configure(with: action)
            return cell
        }
    }
     
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MainView: UICollectionViewDelegateFlowLayout {
    // Return the appropriate size for each item based on the section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            // Return size for PrinterStatusCell
            return CGSize(width: collectionView.bounds.width, height: 370.scale) // Adjust height as needed
        } else {
            // Return size for QuickActionCell
            let width = collectionView.bounds.width - 32.scale
            let height = 78.scale
            return CGSize(width: width, height: height)
        }
    }
}
