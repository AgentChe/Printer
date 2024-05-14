//
//  AlignCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/14/24.
//

import UIKit

class AlignCell: UICollectionViewCell {
    static let identifier = "AlignCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black 
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.backgroundColor = .white
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.clear.cgColor
        }
    }
    
    func configure(with alignment: NSTextAlignment) {
        var imageName = ""
        switch alignment {
        case .left:
            imageName = "text.alignleft"
        case .center:
            imageName = "text.aligncenter"
        case .right:
            imageName = "text.alignright"
        case .justified:
            imageName = "text.justify"
        default:
            break
        }
        imageView.image = UIImage(systemName: imageName)
    }
}
