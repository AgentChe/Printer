//
//  OptionCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/13/24.
//

import UIKit
class OptionCell: UICollectionViewCell {
    static let identifier = "OptionCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 10
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
