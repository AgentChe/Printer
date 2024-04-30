//
//  QuickActionHeaderView.swift
//  Printer
//
//  Created by Niiaz Khasanov on 4/30/24.
//

import UIKit
class QuickActionHeaderView: UICollectionReusableView {
    static let identifier = "QuickActionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SFProDisplay.medium(size: 16)
        label.text = "QUICK ACTIONS"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
