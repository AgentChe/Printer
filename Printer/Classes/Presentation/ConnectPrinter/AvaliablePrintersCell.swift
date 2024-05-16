//
//  AvaliablePrintersCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/10/24.
//

import UIKit

// Define your custom cell classes
class AvaliablePrintersCell: UICollectionViewCell {
    static let availablePrintersCellKey = "availablePrintersCellKey"
    var collectionView: UICollectionView!
    private var actionButton: UIButton! // Define the button
    var foundPrinters: [UIPrinter] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupActionButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20.scale
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(PrinterCell.self, forCellWithReuseIdentifier: PrinterCell.identifier)
        collectionView.register(NoPrinterCell.self, forCellWithReuseIdentifier: NoPrinterCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60.scale), // Leave space for the button
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupActionButton() {
        actionButton = UIButton(type: .system)
        actionButton.setTitle("Don't see your device?", for: .normal)
        actionButton.setTitleColor(Appearance.signatureBlue, for: .normal)
        actionButton.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17) // Set font size and weight
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.backgroundColor = .clear
        addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 3.scale),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension AvaliablePrintersCell: UICollectionViewDelegateFlowLayout {
    // Specify the size for each item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if foundPrinters.count != 0 {
            // You can adjust the width and height according to your needs
            return CGSize(width: 358.scale, height: 92.scale)
        } else {
            return CGSize(width: 358.scale, height: 150.scale)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension AvaliablePrintersCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foundPrinters.isEmpty ? 1 : foundPrinters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !foundPrinters.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrinterCell.identifier, for: indexPath) as? PrinterCell else {
                return UICollectionViewCell()
            }
            let printerURL = foundPrinters[indexPath.item].url
            cell.printerName.text = PrinterManager.shared.getPrinterName(for: printerURL)
            cell.connectionStatusLabel.text = printerURL == PrinterManager.shared.currentlyConnectedPrinterURL ? "Connected" : "Not connected"
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoPrinterCell.identifier, for: indexPath) as? NoPrinterCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension AvaliablePrintersCell {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !foundPrinters.isEmpty else {
            print("No printers are available or cell tapped is NoPrinterCell.")
            return
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? PrinterCell else {
            return
        }
        
        let selectedPrinter = foundPrinters[indexPath.item]
        let isConnected = cell.connectionStatusLabel.text == "Connected"
        
        if !isConnected {
            // Connect to the printer if it is not currently connected
            PrinterManager.shared.connectToPrinter(with: selectedPrinter.url) { [weak self] (printer, error) in
                DispatchQueue.main.async {
                    if let printer = printer {
                        cell.connectionStatusLabel.text = "Connected"
                        print("Successfully connected to \(printer.displayName)")
                    }
                    if let error = error {
                        if let viewController4Alert = self?.parentViewController {
                            let printerName = printer?.displayName ?? "Unknown"
                            PrinterManager.shared.showAlertForErrorWithPrinter(printerName, viewController: viewController4Alert)
                        }
                        print("Error connecting to printer: \(error.localizedDescription)")
                    }
                    collectionView.reloadData()  // Refresh to update connection status labels
                }
            }
        } else {
            // Disconnect the printer if it is currently connected
            PrinterManager.shared.disconnectPrinter()
            cell.connectionStatusLabel.text = "Not connected"
            collectionView.reloadData()  // Refresh to update connection status labels
        }
    }
}
