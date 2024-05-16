//
//  PrinterStatusCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 4/30/24.
//

import UIKit

final class PrinterNotConnectedStatusCell: UICollectionViewCell {

    static let identifier = "PrinterNotConnectedStatusCell"
    
    // Use the existing subviews from MainView
    let printerImageView: UIImageView = {
        let printerImage = UIImage(named: "Printer.Сhecked")
        let imageView = UIImageView(image: printerImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "No printer was added"
        label.font = Fonts.SFProDisplay.bold(size: 19)
        label.textColor = Appearance.black // Use Appearance.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Check your internet connection or add another one"
        label.font = Fonts.SFProDisplay.regular(size: 16)
        label.textColor = Appearance.subtitleLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addPrinterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add printer", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Appearance.signatureBlue // Use Appearance signature blue color
        button.setTitleColor(Appearance.white, for: .normal) // Use Appearance.white
        button.titleLabel?.font = Fonts.SFProDisplay.semiBold(size: 18)
        button.layer.cornerRadius = 24
        button.isUserInteractionEnabled = true
        button.layer.shadowColor = Appearance.signatureBlue?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.4
        
        button.addTarget(self, action: #selector(addPrinterButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let compatibleListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Compatible list", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 18)
        button.setTitleColor(Appearance.signatureBlue, for: .normal) // Use Appearance signature blue color
        button.addTarget(self, action: #selector(compatibleListButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add subviews to the content view of the cell
        addSubview(printerImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(addPrinterButton)
        addSubview(compatibleListButton)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let spacing = CGFloat(10.0) // The space you want between elements
        let buttonHeight = CGFloat(63.0) // The height of the buttons
        
        NSLayoutConstraint.activate([
            // Printer image view constraints
            printerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            printerImageView.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            printerImageView.widthAnchor.constraint(equalToConstant: 130.scale),
            printerImageView.heightAnchor.constraint(equalTo: printerImageView.widthAnchor),
            
            // Title label constraints
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: printerImageView.bottomAnchor, constant: spacing),
            
            // Subtitle label constraints
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing / 2),
            
            // Add printer button constraints
            addPrinterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addPrinterButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: (2 * spacing).scale),
            addPrinterButton.widthAnchor.constraint(equalToConstant: 361.scale),
            addPrinterButton.heightAnchor.constraint(equalToConstant: buttonHeight.scale),
            
            // Compatible list button constraints
            compatibleListButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            compatibleListButton.topAnchor.constraint(equalTo: addPrinterButton.bottomAnchor, constant: (spacing / 4).scale),
            compatibleListButton.widthAnchor.constraint(equalTo: addPrinterButton.widthAnchor),
            compatibleListButton.heightAnchor.constraint(equalTo: addPrinterButton.heightAnchor)
        ])
    }
    
    // Initialize and set up the layout for subviews here...
}

extension PrinterNotConnectedStatusCell {
    // MARK: - Actions
    @objc private func addPrinterButtonTapped() {
        if let rootViewController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController {
            let connectPrinterVC = ConnectPrinterViewController()
            connectPrinterVC.modalPresentationStyle = .fullScreen
            rootViewController.present(connectPrinterVC, animated: true)
        }
    }
    
    @objc private func compatibleListButtonTapped() {
        // Implement the action for the compatible list button
    }
}
