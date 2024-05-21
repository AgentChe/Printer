//
//  PrinterCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/10/24.
//

import UIKit

class PrinterCell: UICollectionViewCell {
    static let identifier = "PrinterCellIdentifier"

    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear // Use Appearance.mainViewBackground
        view.layer.cornerRadius = 12.scale // The corner radius for rounded corners
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let printerImage = UIImage(named: "PrinterCell.Printer")
        let imageView = UIImageView(image: printerImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
     let checkmarkImageView: UIImageView = {
        let checkmarkImage = UIImage(named: "PrinterCell.Checkmark")
        let imageView = UIImageView(image: checkmarkImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 1 // Initial opacity set to 0
        return imageView
    }()
    
    let printerName: UILabel = {
        let label = UILabel()
        label.font = Fonts.SFProDisplay.regular(size: 17.scale) // Set custom font
        label.text = NSLocalizedString("PrinterCell.PrinterName", comment: "Printer N1234")
        label.textColor = Appearance.black // Use Appearance.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let connectionStatusLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SFProDisplay.regular(size: 17.scale) // Set custom font
        label.text = NSLocalizedString("PrinterCell.ConnectionStatus.NotConnected", comment: "Not connected")
        label.textColor = Appearance.subtitleLabelColor // Use Appearance.subtitleLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Appearance.white // Use Appearance.white
        layer.cornerRadius = 20.scale
        clipsToBounds = true
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        addSubview(printerName)
        addSubview(connectionStatusLabel)
        addSubview(checkmarkImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Icon Container View Constraints
            iconContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            iconContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 48.scale), // Adjust the size accordingly
            iconContainerView.heightAnchor.constraint(equalTo: iconContainerView.widthAnchor),
            
            // Icon ImageView Constraints
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24.scale), // Adjust your size
            iconImageView.heightAnchor.constraint(equalToConstant: 24.scale), // Adjust your size
            
            // Checkmark ImageView Constraints
            checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 23.scale),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24.scale),
            
            // Title Label Constraints
            printerName.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 10.scale),
            printerName.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -30.scale),
            printerName.topAnchor.constraint(equalTo: topAnchor, constant: 22.6.scale),
            
            // Detail Label Constraints
            connectionStatusLabel.leadingAnchor.constraint(equalTo: printerName.leadingAnchor),
            connectionStatusLabel.trailingAnchor.constraint(equalTo: printerName.trailingAnchor),
            connectionStatusLabel.topAnchor.constraint(equalTo: printerName.bottomAnchor, constant: 5.scale)
        ])
    }
    
    func configure(with action: QuickAction, isConnected: Bool) {
        iconImageView.image = action.icon
        printerName.text = action.title
        connectionStatusLabel.text = action.detail // Assuming QuickAction now has a 'detail' property for additional text
        checkmarkImageView.alpha = isConnected ? 1 : 0 // Show checkmark if connected
    }
}
