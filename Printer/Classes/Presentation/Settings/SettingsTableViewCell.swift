// SettingsTableViewCell.swift
// Printer

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell"
    private let customSeparator = UIView()
    private let customDisclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Cell styling
        self.textLabel?.font = UIFont.systemFont(ofSize: 17.scale) // Set as needed
        self.textLabel?.textColor = Appearance.black // Use Appearance.black
        self.selectionStyle = .none
        backgroundColor = Appearance.white // Use Appearance.white
        setupSeparator()
        setupDisclosureIndicator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSeparator() {
        customSeparator.backgroundColor = Appearance.customSeparatorColor
        customSeparator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customSeparator)

        NSLayoutConstraint.activate([
            customSeparator.heightAnchor.constraint(equalToConstant: 1.scale),
            customSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.scale), // Adjust insets as needed
            customSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        customSeparator.isHidden = true // Hide by default
    }

    private func setupDisclosureIndicator() {
        customDisclosureIndicator.tintColor = Appearance.black // Set the color to black
        customDisclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(customDisclosureIndicator)

        NSLayoutConstraint.activate([
            customDisclosureIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.scale),
            customDisclosureIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customDisclosureIndicator.widthAnchor.constraint(equalToConstant: 12.scale),
            customDisclosureIndicator.heightAnchor.constraint(equalToConstant: 20.scale)
        ])
    }

    func showSeparator() {
        customSeparator.isHidden = false
    }

    func hideSeparator() {
        customSeparator.isHidden = true
    }

    // Call this method to round corners for specific cells
    func roundCorners(top: Bool, bottom: Bool) {
        self.layer.cornerRadius = 24.scale // Set your desired radius
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
