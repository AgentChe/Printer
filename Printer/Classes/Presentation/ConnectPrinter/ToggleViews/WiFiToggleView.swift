//
//  WiFiToggleView.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/9/24.
//

import UIKit
class WifiToggleView: UIView {
    
    // UIImageView for the Bluetooth icon
    private let WiFiIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ToggleView.WiFi"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // UILabel for the Bluetooth text
    private let WiFiLabel: UILabel = {
        let label = UILabel()
        label.text = "Wi-fi"
        label.font = UIFont.systemFont(ofSize: 17) // Customize the font size as needed
        return label
    }()
    
    // UIImageView to simulate the toggle switch (non-interactive)
    private let WiFiSwitch: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ToggleView.SwitchOff")) // Default to off state
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = .white
        layer.cornerRadius = 24
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(WiFiIcon)
        addSubview(WiFiLabel)
        addSubview(WiFiSwitch)
        
        WiFiIcon.translatesAutoresizingMaskIntoConstraints = false
        WiFiLabel.translatesAutoresizingMaskIntoConstraints = false
        WiFiSwitch.translatesAutoresizingMaskIntoConstraints = false
        
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
