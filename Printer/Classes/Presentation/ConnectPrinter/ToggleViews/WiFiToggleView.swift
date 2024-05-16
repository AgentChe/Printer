// WiFiToggleView.swift
// Printer

import UIKit

class WifiToggleView: UIView {
    
    // UIImageView for the WiFi icon
    private let WiFiIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ToggleView.WiFi"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Appearance.black // Use Appearance.black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // UILabel for the WiFi text
    private let WiFiLabel: UILabel = {
        let label = UILabel()
        label.text = "Wi-fi"
        label.font = Fonts.SFProDisplay.regular(size: 17.scale) // Customize the font size as needed
        label.textColor = Appearance.black // Use Appearance.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // UIImageView to simulate the toggle switch (non-interactive)
    private let WiFiSwitch: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ToggleView.SwitchOff")) // Default to off state
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = Appearance.white // Use Appearance.white
        layer.cornerRadius = 24.scale
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(WiFiIcon)
        addSubview(WiFiLabel)
        addSubview(WiFiSwitch)
        
        NSLayoutConstraint.activate([
            WiFiIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            WiFiIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            WiFiIcon.widthAnchor.constraint(equalToConstant: 30.scale),
            WiFiIcon.heightAnchor.constraint(equalToConstant: 30.scale),

            WiFiLabel.leadingAnchor.constraint(equalTo: WiFiIcon.trailingAnchor, constant: 15.scale),
            WiFiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            WiFiSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            WiFiSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            WiFiSwitch.widthAnchor.constraint(equalToConstant: 51.scale), // Width based on typical UISwitch size
            WiFiSwitch.heightAnchor.constraint(equalToConstant: 31.scale) // Height based on typical UISwitch size
        ])
    }
}

extension WifiToggleView {
    // Method to update the WiFi switch image
    func updateSwitchImage(with imageName: String) {
        // Load the new image from the assets
        let newImage = UIImage(named: imageName)
        
        // Update the WiFiSwitch UIImageView's image
        WiFiSwitch.image = newImage
    }
}
