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
        view.backgroundColor = .clear//UIColor.systemBlue.withAlphaComponent(0.12) // Light blue background
        view.layer.cornerRadius = 12 // The corner radius for rounded corners
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Drop shadow configuration
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let printerImage = UIImage(named: "PrinterCell.Printer")
        let imageView = UIImageView(image:printerImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let printerName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.scale, weight: .regular)
        label.text = "Printer N1234"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let connectionStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.scale, weight: .regular)
        label.text = "Not connected"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white // Use the Appearance framework or your theme settings to set this
        layer.cornerRadius = 20
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
            
            // Title Label Constraints
            printerName.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 10.scale),
            printerName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.scale),
            printerName.topAnchor.constraint(equalTo: topAnchor, constant: 22.6.scale),
            
            // Detail Label Constraints
            connectionStatusLabel.leadingAnchor.constraint(equalTo: printerName.leadingAnchor),
            connectionStatusLabel.trailingAnchor.constraint(equalTo: printerName.trailingAnchor),
            connectionStatusLabel.topAnchor.constraint(equalTo: printerName.bottomAnchor, constant: 5.scale)
        ])
    }
    
    func configure(with action: QuickAction) {
        iconImageView.image = action.icon
        printerName.text = action.title
        connectionStatusLabel.text = action.detail // Assuming QuickAction now has a 'detail' property for additional text
    }
}
 
