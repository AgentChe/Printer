//
//  PrinterConnectedStatusCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/11/24.
//

import UIKit
final class PrinterConnectedStatusCell: UICollectionViewCell {
    
    static let identifier = "PrinterConnectedStatusCell"
    
    // Use the existing subviews from MainView
    let printerImageView: UIImageView = {
        let printerImage = UIImage(named: "Printer.Checked")
        let imageView = UIImageView(image: printerImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Printer 1234 is connected"
        label.numberOfLines = 0
        label.font = Fonts.SFProDisplay.bold(size: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        // Set the style for the title label
        return label
    }()
    
    
    
    private let changePrinterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change printer", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear // Use a color picker to get the exact color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 18)
        // Use UIFont to set the font and size according to your design
        button.setTitleColor(Appearance.signatureBlue, for: .normal)
        
        
        // Set the target-action for the button tap event
        button.addTarget(self, action: #selector(addPrinterButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let compatibleListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Compatible list", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 18)
        // Настройте стиль кнопки и действие
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(compatibleListButtonTapped), for: .touchUpInside)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add subviews to the content view of the cell
        addSubview(printerImageView)
        addSubview(titleLabel)
        addSubview(changePrinterButton)
        // addSubview(compatibleListButton)
        setupLayout()
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupLayout() {
        let spacing = CGFloat(10.0.scale) // The space you want between elements
        let buttonHeight = CGFloat(20.0.scale) // The height of the buttons
        
        NSLayoutConstraint.activate([
            // Printer image view constraints
            // Compatible list button constraints
            //            compatibleListButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            //            compatibleListButton.topAnchor.constraint(equalTo: topAnchor, constant: (spacing / 4).scale),
            //            compatibleListButton.widthAnchor.constraint(equalToConstant: 130.scale), // Same width as add printer button
            //            compatibleListButton.heightAnchor.constraint(equalToConstant: 21.scale), // Same height as add printer button
            
            printerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            printerImageView.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            printerImageView.widthAnchor.constraint(equalToConstant: 130.scale), // Adjust multiplier for the desired width
            printerImageView.heightAnchor.constraint(equalTo: printerImageView.widthAnchor), // Makes the image view square
            
            // Title label constraints
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: printerImageView.bottomAnchor, constant: spacing),
            titleLabel.widthAnchor.constraint(equalToConstant: 361.scale),
            
            
            // Add printer button constraints
            changePrinterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            changePrinterButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: (1.2*spacing).scale),
            changePrinterButton.widthAnchor.constraint(equalToConstant: 361.scale),
            changePrinterButton.heightAnchor.constraint(equalToConstant: buttonHeight.scale),
            
            
        ])
        
        // If you're using custom scaling, replace the CGFloat constants with your `.scale` adjusted values.
    }
    // Initialize and set up the layout for subviews here...
}
extension PrinterConnectedStatusCell {
    // MARK: - Actions
    @objc private func addPrinterButtonTapped() {
        //delegate?.didTapAddPrinter()
        
        if let rootViewController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController {
            let connectPrinterVC = ConnectPrinterViewController()
            connectPrinterVC.modalPresentationStyle = .fullScreen // Set the presentation style to fullscreen
            rootViewController.present(connectPrinterVC, animated: true)
        }
        
        
        
    }
    
    @objc private func compatibleListButtonTapped() {
        // delegate?.didTapCompatibleList()
    }
}
