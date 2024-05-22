import UIKit

final class PrinterConnectedStatusCell: UICollectionViewCell {
    
    static let identifier = "PrinterConnectedStatusCell"
    
    // Use the existing subviews from MainView
    let printerImageView: UIImageView = {
        let printerImage = UIImage(named: "Printer.Сhecked")
        let imageView = UIImageView(image: printerImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Printer 1234 is connected"
        label.numberOfLines = 0
        label.font = Fonts.SFProDisplay.bold(size: 19.scale)
        label.textColor = Appearance.black // Use Appearance.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let changePrinterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change printer", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(Appearance.signatureBlue, for: .normal) // Use Appearance.signatureBlue
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 18.scale)
        button.addTarget(self, action: #selector(addPrinterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let compatibleListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Compatible list", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 18.scale)
        button.setTitleColor(Appearance.signatureBlue, for: .normal) // Use Appearance.signatureBlue
        button.addTarget(self, action: #selector(compatibleListButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let myPrinterLabel: UILabel = {
        let label = UILabel()
        label.text = "My printer"
        label.font = Fonts.SFProDisplay.bold(size: 24.scale)
        label.textColor = Appearance.black // Use Appearance.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add subviews to the content view of the cell
        addSubview(printerImageView)
        addSubview(titleLabel)
        addSubview(changePrinterButton)
        addSubview(myPrinterLabel)
        addSubview(compatibleListButton)
        setupLayout()
        backgroundColor = Appearance.background // Use Appearance.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let spacing = CGFloat(10.0).scale // The space you want between elements
        let buttonHeight = CGFloat(20.0).scale // The height of the buttons
        
        NSLayoutConstraint.activate([
            // My printer label constraints
            myPrinterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            myPrinterLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            
            // Printer image view constraints
            printerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            printerImageView.topAnchor.constraint(equalTo: myPrinterLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? spacing + 42.scale : spacing + 42.scale),
            printerImageView.widthAnchor.constraint(equalToConstant: 130.scale), // Adjust multiplier for the desired width
            printerImageView.heightAnchor.constraint(equalTo: printerImageView.widthAnchor), // Makes the image view square
            
            // Title label constraints
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: printerImageView.bottomAnchor, constant: spacing),
            titleLabel.widthAnchor.constraint(equalToConstant: 361.scale),
            
            // Change printer button constraints
            changePrinterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            changePrinterButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: (1.2 * spacing).scale),
            changePrinterButton.widthAnchor.constraint(equalToConstant: 361.scale),
            changePrinterButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            // Compatible list button constraints
            compatibleListButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            compatibleListButton.centerYAnchor.constraint(equalTo: myPrinterLabel.centerYAnchor, constant: 0.scale),
            compatibleListButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
}

extension PrinterConnectedStatusCell {
    // MARK: - Actions
    @objc private func addPrinterButtonTapped() {
        if let rootViewController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController {
            let connectPrinterVC = ConnectPrinterViewController()
            connectPrinterVC.modalPresentationStyle = .fullScreen
            rootViewController.present(connectPrinterVC, animated: true)
        }
    }
    
    @objc private func compatibleListButtonTapped() {
        // Implement the action for the compatible list button
         
        if let rootViewController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController {
            let brandsVC = NavigationController(rootViewController:BrandsTableViewController())
            rootViewController.present(brandsVC, animated: true)
        }
    }
    
}
