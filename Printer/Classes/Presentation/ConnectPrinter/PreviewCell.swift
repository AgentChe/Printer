import UIKit

class PreviewCell: UICollectionViewCell {
    static let identifier = "PreviewCellIdentifier"

    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.SFProDisplay.regular(size: 15.scale) // Custom font
        label.textColor = Appearance.black // Set color to Appearance.black
        label.text = "page 1 of 3"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(previewImageView)
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: topAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8.scale), // Adjust the spacing as needed
            
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20.scale) // Adjust the height as needed
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with image: UIImage, description: String) {
        previewImageView.image = image
        descriptionLabel.text = description
    }
}
