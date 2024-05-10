//
//  NoPrinterCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/10/24.
//

import UIKit
class NoPrinterCell: UICollectionViewCell {
    static let identifier = "NoPrinterCellIdentifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .yellow
        // Add more UI setup here if necessary
    }
}
