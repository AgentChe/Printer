//
//  PagesPerSheetCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/12/24.
//

import UIKit
class PagesPerSheetCell_v0: UICollectionViewCell {
    var imageBgView: UIView!
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configureBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBorder() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            updateBorder()
        }
    }
    
    private func updateBorder() {
        if isSelected {
            imageBgView.layer.borderWidth = 1.5.scale
            imageBgView.layer.borderColor = UIColor.blue.cgColor
        } else {
            imageBgView.layer.borderWidth = 0
            imageBgView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        
        // Setting up the background view for the image
        imageBgView = UIView()
        imageBgView.backgroundColor = UIColor(red: 243/255.0, green: 245/255.0, blue: 253/255.0, alpha: 1) // #F3F5FD
        imageBgView.layer.cornerRadius = 12
        imageBgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageBgView)
        
        // Setting up the image view inside the background view
        imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageBgView.addSubview(imageView)
        
        // Setting up the label below the image background view
        label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.SFProDisplay.medium(size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            // Constraints for image background view
            imageBgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageBgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10.scale),
            imageBgView.widthAnchor.constraint(equalToConstant: 44.scale),
            imageBgView.heightAnchor.constraint(equalToConstant: 44.scale),
            
            // Constraints for image view
            imageView.centerXAnchor.constraint(equalTo: imageBgView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageBgView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 14.scale),
            imageView.heightAnchor.constraint(equalToConstant: 20.scale),
            
            // Constraints for label
            label.topAnchor.constraint(equalTo: imageBgView.bottomAnchor, constant: 5.scale),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: 30.scale),
            label.heightAnchor.constraint(equalToConstant: 18.scale)
        ])
    }
}

extension PagesPerSheetCell_v0 {
    static let reuseIdentifier = "PagesPerSheetCell"
}
