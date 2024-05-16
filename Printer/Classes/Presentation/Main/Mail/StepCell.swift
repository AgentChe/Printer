import UIKit

struct StepData {
    let title: String
    let subtitle: String
    let description: String
    let image: UIImage?
}

class StepCell: UICollectionViewCell {
    
    static let identifier = "StepCell"
    
    private let stepTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SFProDisplay.regular(size: 13)//UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = Appearance.signatureBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stepSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SFProDisplay.bold(size: 19)//UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = Appearance.black
        label.letterSpacing = 0.36
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stepDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SFProDisplay.regular(size: 13)//UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var stepDescriptionHeightConstraint: NSLayoutConstraint!
    
    private let stepImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stepTitleLabel)
        contentView.addSubview(stepSubtitleLabel)
        contentView.addSubview(stepDescriptionLabel)
        contentView.addSubview(stepImageView)
        
        NSLayoutConstraint.activate([
            stepTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stepTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            stepTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            stepTitleLabel.heightAnchor.constraint(equalToConstant: 15),

            stepSubtitleLabel.topAnchor.constraint(equalTo: stepTitleLabel.bottomAnchor, constant: 4),
            stepSubtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            stepSubtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            stepSubtitleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            stepDescriptionLabel.topAnchor.constraint(equalTo: stepSubtitleLabel.bottomAnchor, constant: 3),
            stepDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            stepDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            
            stepImageView.topAnchor.constraint(equalTo: stepDescriptionLabel.bottomAnchor, constant: 10),
            stepImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stepImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stepImageView.heightAnchor.constraint(equalToConstant: 212),
            stepImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        stepDescriptionHeightConstraint = stepDescriptionLabel.heightAnchor.constraint(equalToConstant: 20)
        stepDescriptionHeightConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: StepData, index: Int) {
        stepTitleLabel.text = data.title
        stepSubtitleLabel.text = data.subtitle
        stepDescriptionLabel.text = data.description
        stepImageView.image = data.image
        
        // Adjust the height constraint based on the index
        stepDescriptionHeightConstraint.constant = (index == 0) ? 16 : 37
        stepDescriptionHeightConstraint.constant = (index == 3) ? 60 : stepDescriptionHeightConstraint.constant
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the description label uses the full width available
        stepDescriptionLabel.preferredMaxLayoutWidth = stepDescriptionLabel.bounds.width
    }
}

// Extension to add letterSpacing to UILabel
extension UILabel {
    var letterSpacing: CGFloat {
        get {
            if let letterSpacing = attributedText?.attribute(.kern, at: 0, effectiveRange: nil) as? CGFloat {
                return letterSpacing
            }
            return 0
        }
        set {
            let attributedString: NSMutableAttributedString
            if let attributedText = attributedText {
                attributedString = NSMutableAttributedString(attributedString: attributedText)
            } else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            attributedString.addAttribute(.kern, value: newValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
}
