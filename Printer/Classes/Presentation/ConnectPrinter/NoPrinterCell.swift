//
//  NoPrinterCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/10/24.
//

import UIKit

class NoPrinterCell: UICollectionViewCell {
    static let identifier = "NoPrinterCellIdentifier"
    
    private let noPrinterImageView: UIImageView = {
        let noPrinterImage = UIImage(named: "PrinterCell.NoPrinter")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: noPrinterImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Appearance.black // Use Appearance.black
        return imageView
    }()
    
    private let noPrintersLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SFProDisplay.medium(size: 17.scale) // Set custom font
        label.text = NSLocalizedString("NoPrinterCell.NoPrintersAdded", comment: "No Printers Added")
        label.textAlignment = .center
        label.textColor = Appearance.subtitleLabelColor // Use Appearance.subtitleLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        addSubview(noPrinterImageView)
        addSubview(noPrintersLabel)
        
        NSLayoutConstraint.activate([
            // Center the imageView in the cell
            noPrinterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noPrinterImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: ScreenSize.isIphoneXFamily ? 0.scale : 0.scale),
            noPrinterImageView.widthAnchor.constraint(equalToConstant: 33.scale),
            noPrinterImageView.heightAnchor.constraint(equalToConstant: 29.scale),
            
            noPrintersLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noPrintersLabel.topAnchor.constraint(equalTo: noPrinterImageView.bottomAnchor, constant: 16.scale),
            noPrintersLabel.widthAnchor.constraint(equalTo: widthAnchor),
            noPrintersLabel.heightAnchor.constraint(equalToConstant: 20.scale)
        ])
    }
}
