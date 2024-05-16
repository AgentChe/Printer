//
//  QuickActionCell.swift
//
//
//  Created by Niiaz Khasanov on 4/29/24.
//

import UIKit

final class QuickActionCell: UICollectionViewCell {
    static let identifier = "QuickActionCell"
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Appearance.signatureBlue?.withAlphaComponent(0.12) // Light blue background from Appearance
        view.layer.cornerRadius = 12 // The corner radius for rounded corners
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Drop shadow configuration
        view.layer.shadowColor = Appearance.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.textColor = Appearance.black // Use Appearance.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = Appearance.subtitleLabelColor // Use Appearance.subtitleLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Appearance.white // Use Appearance.white
        layer.cornerRadius = 20
        clipsToBounds = true
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Icon Container View Constraints
            iconContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.scale),
            iconContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 48.scale), // Adjust the size accordingly
            iconContainerView.heightAnchor.constraint(equalTo: iconContainerView.widthAnchor),
            
            // Icon ImageView Constraints
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24.scale), // Adjust your size
            iconImageView.heightAnchor.constraint(equalToConstant: 24.scale), // Adjust your size
            
            // Title Label Constraints
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 20.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scale),
            
            // Detail Label Constraints
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0.scale)
        ])
    }
    
    func configure(with action: QuickAction) {
        iconImageView.image = action.icon
        titleLabel.text = action.title
        detailLabel.text = action.detail // Assuming QuickAction now has a 'detail' property for additional text
    }
}
