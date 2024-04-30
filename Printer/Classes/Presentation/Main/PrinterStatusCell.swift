//
//  PrinterStatusCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 4/30/24.
//

import UIKit
final class PrinterStatusCell: UICollectionViewCell {
    static let identifier = "PrinterStatusCell"
    
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
        label.text = "No printer was added"
        label.font = Fonts.SFProDisplay.bold(size: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        // Set the style for the title label
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Check you internet connection or add another one"
        label.font = Fonts.SFProDisplay.regular(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        // Set the style for the subtitle label
        return label
    }()
    
    private let addPrinterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add printer", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue // Use a color picker to get the exact color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.SFProDisplay.semiBold(size: 18)
        // Use UIFont to set the font and size according to your design
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // Adjust the font size accordingly

        // Corner radius for rounded corners
        button.layer.cornerRadius = 24 // Adjust the corner radius to match your design
        
        // Shadow properties
        button.layer.shadowColor = Appearance.addPrinterColor?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0) // These values will need tweaking
        button.layer.shadowRadius = 6 // Adjust the blur radius to match your design
        button.layer.shadowOpacity = 0.4 // Adjust the opacity to match your design
        
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
         addSubview(subtitleLabel)
         addSubview(addPrinterButton)
         addSubview(compatibleListButton)
         
         setupLayout()
     }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupLayout() {
        let spacing = CGFloat(20.0) // The space you want between elements
        let buttonHeight = CGFloat(50.0) // The height of the buttons
        
        NSLayoutConstraint.activate([
            // Printer image view constraints
            printerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            printerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            printerImageView.widthAnchor.constraint(equalToConstant: 130.scale), // Adjust multiplier for the desired width
            printerImageView.heightAnchor.constraint(equalTo: printerImageView.widthAnchor), // Makes the image view square
            
            // Title label constraints
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: printerImageView.bottomAnchor, constant: spacing),
            
            // Subtitle label constraints
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing / 2),
            
            // Add printer button constraints
            addPrinterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addPrinterButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: spacing),
            addPrinterButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8), // 80% of contentView's width
            addPrinterButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            // Compatible list button constraints
            compatibleListButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            compatibleListButton.topAnchor.constraint(equalTo: addPrinterButton.bottomAnchor, constant: spacing / 2),
            compatibleListButton.widthAnchor.constraint(equalTo: addPrinterButton.widthAnchor), // Same width as add printer button
            compatibleListButton.heightAnchor.constraint(equalTo: addPrinterButton.heightAnchor) // Same height as add printer button
        ])
        
        // If you're using custom scaling, replace the CGFloat constants with your `.scale` adjusted values.
    }
    // Initialize and set up the layout for subviews here...
}
extension PrinterStatusCell {
    // MARK: - Actions
    @objc private func addPrinterButtonTapped() {
       // delegate?.didTapAddPrinter()
    }
    
    @objc private func compatibleListButtonTapped() {
       // delegate?.didTapCompatibleList()
    }
}
