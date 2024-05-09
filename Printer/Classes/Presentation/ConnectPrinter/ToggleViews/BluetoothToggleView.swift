//
//  BluetoothToggleView.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/9/24.
//

import UIKit

class BluetoothToggleView: UIView {
    
    // UIImageView for the Bluetooth icon
    private let bluetoothIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ToggleView.Bluetooth"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // UILabel for the Bluetooth text
    private let bluetoothLabel: UILabel = {
        let label = UILabel()
        label.text = "Bluetooth"
        label.font = UIFont.systemFont(ofSize: 17) // Customize the font size as needed
        return label
    }()
    
    // UIImageView to simulate the toggle switch (non-interactive)
    private let bluetoothSwitch: UIImageView = {
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
        addSubview(bluetoothIcon)
        addSubview(bluetoothLabel)
        addSubview(bluetoothSwitch)
        
        bluetoothIcon.translatesAutoresizingMaskIntoConstraints = false
        bluetoothLabel.translatesAutoresizingMaskIntoConstraints = false
        bluetoothSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bluetoothIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            bluetoothIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            bluetoothIcon.widthAnchor.constraint(equalToConstant: 30.scale),
            bluetoothIcon.heightAnchor.constraint(equalToConstant: 30.scale),

            bluetoothLabel.leadingAnchor.constraint(equalTo: bluetoothIcon.trailingAnchor, constant: 15.scale),
            bluetoothLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bluetoothSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            bluetoothSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            bluetoothSwitch.widthAnchor.constraint(equalToConstant: 51.scale), // Width based on typical UISwitch size
            bluetoothSwitch.heightAnchor.constraint(equalToConstant: 31.scale) // Height based on typical UISwitch size
        ])
    }
}
extension BluetoothToggleView {
    // Method to update the Bluetooth switch image
    func updateSwitchImage(with imageName: String) {
        // Load the new image from the assets
        let newImage = UIImage(named: imageName)
        
        // Update the bluetoothSwitch UIImageView's image
        bluetoothSwitch.image = newImage
    }
}
