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

class MainView: UIView {
    weak var delegate: MainViewDelegate?
    var quickActions: [QuickAction] = []
    var isAnimatingNavigationBar: Bool = false

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(QuickActionCell.self, forCellWithReuseIdentifier: QuickActionCell.identifier)
        cv.register(PrinterNotConnectedStatusCell.self, forCellWithReuseIdentifier: PrinterNotConnectedStatusCell.identifier)
        cv.register(PrinterConnectedStatusCell.self, forCellWithReuseIdentifier: PrinterConnectedStatusCell.identifier)
        cv.register(QuickActionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QuickActionHeaderView.identifier)
        cv.contentInset = UIEdgeInsets(top: 0.scale, left: 0.scale, bottom: 15.scale, right: 0.scale)
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
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.scale)
        ])
    }
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
            if PrinterManager.shared.currentlyConnectedPrinterURL != nil {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrinterConnectedStatusCell.identifier, for: indexPath) as! PrinterConnectedStatusCell
                let currentlyConnectedPrinterURL = PrinterManager.shared.currentlyConnectedPrinterURL!
                let printerName = PrinterManager.shared.getPrinterName(for: currentlyConnectedPrinterURL)!
                let cleanedPrinterName = printerName.filter { $0 != "\"" }  // Remove all " characters
                let truncatedPrinterName = String(cleanedPrinterName.prefix(10))  // Keep only the first 10 characters
                cell.titleLabel.text = String(format: NSLocalizedString("MainView.PrinterConnected", comment: ""), truncatedPrinterName)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrinterNotConnectedStatusCell.identifier, for: indexPath) as! PrinterNotConnectedStatusCell
                cell.titleLabel.text = NSLocalizedString("MainView.PrinterNotConnected", comment: "")
                return cell
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickActionCell.identifier, for: indexPath) as? QuickActionCell else {
                fatalError("Could not dequeue QuickActionCell")
            }
            let action = quickActions[indexPath.row]
            cell.configure(with: action)
            //cell.titleLabel.font = Fonts.SFProDisplay.medium(size: 17.scale) // Set custom font
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 1 { // We only want a header for the second section
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: QuickActionHeaderView.identifier, for: indexPath) as! QuickActionHeaderView
                // Configure your header if needed
                header.titleLabel.font = Fonts.SFProDisplay.bold(size: 17.scale) // Set custom font for header
                return header
            }
            // If you don't want a header for other sections, you should create a default UICollectionReusableView here
            return UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let action = quickActions[indexPath.row]
            delegate?.didSelectQuickAction(action)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainView: UICollectionViewDelegateFlowLayout {
    // Return the appropriate size for each item based on the section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.bounds.width, height: 60.scale) // Adjust the height to match your design
        }
        return CGSize.zero // No header for other sections
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            // Return size for PrinterStatusCell
            if PrinterManager.shared.currentlyConnectedPrinterURL != nil {
                return CGSize(width: collectionView.bounds.width, height: 300.scale)
            } else {
                return CGSize(width: collectionView.bounds.width, height: 400.scale) // Adjust height as needed
            }
        } else {
            // Return size for QuickActionCell
            let width = collectionView.bounds.width - 32.scale
            let height = 78.scale
            return CGSize(width: width, height: height)
        }
    }
}

// MARK: - ConnectPrinterCellDelegate

extension MainView: ConnectPrinterCellDelegate {
    // Get reference to the UICollectionView
    func getCollectionView() -> UICollectionView? {
        return collectionView
    }

    // Reload the UICollectionView
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    // Dismiss the current ViewController hosting this view
    func dismissViewController() {
        DispatchQueue.main.async {
            // Assuming the view controller that contains this view is presented modally
            if let viewController = self.findViewController() {
                viewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// Helper extension to find the view controller that hosts a specific view

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
