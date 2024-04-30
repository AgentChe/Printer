//
//  SettingsTableViewCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 4/30/24.
//

import UIKit
class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell"
    private let customSeparator = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Cell styling
        self.textLabel?.font = UIFont.systemFont(ofSize: 17) // Set as needed
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        backgroundColor = Appearance.white
        setupSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupSeparator() {
        customSeparator.backgroundColor = Appearance.customSeparatorColor 
           customSeparator.translatesAutoresizingMaskIntoConstraints = false
           contentView.addSubview(customSeparator)
           
           NSLayoutConstraint.activate([
               customSeparator.heightAnchor.constraint(equalToConstant: 1),
               customSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15), // Adjust insets as needed
               customSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               customSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
           ])
           
           customSeparator.isHidden = true // Hide by default
       }
    func showSeparator() {
            customSeparator.isHidden = false
        }

        func hideSeparator() {
            customSeparator.isHidden = true
        }
    // Call this method to round corners for specific cells
    func roundCorners(top: Bool, bottom: Bool) {
        self.layer.cornerRadius = 24 // Set your desired radius
        self.layer.maskedCorners = []
        if top {
            self.layer.maskedCorners.insert(.layerMinXMinYCorner)
            self.layer.maskedCorners.insert(.layerMaxXMinYCorner)
        }
        if bottom {
            self.layer.maskedCorners.insert(.layerMinXMaxYCorner)
            self.layer.maskedCorners.insert(.layerMaxXMaxYCorner)
        }
    }
}
