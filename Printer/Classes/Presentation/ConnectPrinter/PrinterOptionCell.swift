//
//  OptionCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/13/24.
//

import UIKit
class PrinterOptionCell: UICollectionViewCell {
    static let identifier = "PrinterOptionCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        
        // Creating the line view
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = Appearance.signatureBlue  // Set the color of the line
        lineView.alpha = 0.5
        // Adding the line view to the contentView
        contentView.addSubview(lineView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // Constraints for the line view
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.4)  // Height of the line
        ])

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
    }
    
    func configure(with title: String, detail: String) {
        titleLabel.text = title
        detailLabel.text = detail
    }
}

