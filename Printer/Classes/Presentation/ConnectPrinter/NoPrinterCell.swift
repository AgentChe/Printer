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
        imageView.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return imageView
    }()
    
    private let noPrimtersLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SFProDisplay.medium(size: 17)
        label.text = "No Printers Added"
        label.textAlignment = .center
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
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
        addSubview(noPrimtersLabel)
        
        NSLayoutConstraint.activate([
            // Center the imageView in the cell
            noPrinterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noPrinterImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.scale),
            noPrinterImageView.widthAnchor.constraint(equalToConstant: 33.scale),
            noPrinterImageView.heightAnchor.constraint(equalToConstant: 29.scale),
            
            noPrimtersLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noPrimtersLabel.topAnchor.constraint(equalTo: noPrinterImageView.bottomAnchor, constant: 16.scale),
            noPrimtersLabel.widthAnchor.constraint(equalTo: widthAnchor),
            noPrimtersLabel.heightAnchor.constraint(equalToConstant: 20.scale)
        ])
    }
}
