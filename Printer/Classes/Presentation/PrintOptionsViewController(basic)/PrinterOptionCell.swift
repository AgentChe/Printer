import UIKit

class PrinterOptionCell: UICollectionViewCell {
    static let identifier = "PrinterOptionCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Fonts.SFProDisplay.medium(size: 17.scale) // Custom font
        label.textColor = Appearance.black // Set text color to Appearance.black
        return label
    }()

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = Fonts.SFProDisplay.regular(size: 15.scale) // Custom font
        label.textColor = Appearance.subtitleLabelColor // Set text color to Appearance.subtitleLabelColor
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "arrow_right") // Use system chevron image
        imageView.tintColor = Appearance.subtitleLabelColor // Set the tint color to match the detailLabel color
        return imageView
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
        contentView.addSubview(arrowImageView)
        
        // Creating the line view
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = Appearance.signatureBlue // Set the color of the line
        lineView.alpha = 0.5
        // Adding the line view to the contentView
        contentView.addSubview(lineView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.scale),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            detailLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -5.scale),
            detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0.scale),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24.scale),

            // Constraints for the line view
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.scale),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0.scale),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.4.scale) // Height of the line
        ])

        contentView.backgroundColor = Appearance.white // Set background color to Appearance.white
        contentView.layer.cornerRadius = 10.scale
    }
    
    func configure(with title: String, detail: String, showArrow: Bool) {
        titleLabel.text = title
        detailLabel.text = detail
        arrowImageView.isHidden = !showArrow
    }
}
