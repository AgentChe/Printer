//  SeekForAccesToScanViewController.swift
//  Printer

import UIKit

class SeekForAccesToScanViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    // UI Components
    private let dismissButton = UIButton(type: .system)
    private let imageView = UIImageView()
    private let headerLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let settingsView = CustomView(frame: .zero, imageName: "SeekForAccess.Settings", labelText: "Go To Settings")
    private let cameraView = CustomView(frame: .zero, imageName: "SeekForAccess.Camera", labelText: "Allow access to Camera")
    private let goToSettingsButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Appearance.white // Use Appearance.white
        setupUI()
    }

    private func setupUI() {
        setupDismissButton()
        setupImageView()
        setupLabels()
        setupSettingsAccess()
        setupCameraAccess()
        setupGoToSettingsButton()
    }

    private func setupDismissButton() {
        let dismissImage = UIImage(named: "SeekForAccess.Dismiss")?.withRenderingMode(.alwaysTemplate)
        dismissButton.setImage(dismissImage, for: .normal)
        dismissButton.tintColor = Appearance.black  // Use Appearance.black
        dismissButton.imageView?.contentMode = .scaleAspectFit  // Ensure the image is aspect fit
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.scale),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23.scale),
            dismissButton.widthAnchor.constraint(equalToConstant: 17.scale),
            dismissButton.heightAnchor.constraint(equalToConstant: 17.scale)
        ])
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    private func setupImageView() {
        imageView.image = UIImage(named: "Printer.Access") // Ensure this asset is added in your Xcode project
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ScreenSize.isIphoneXFamily ? 70.scale : 20.scale),
            imageView.widthAnchor.constraint(equalToConstant: 346.scale),
            imageView.heightAnchor.constraint(equalToConstant: 282.scale)
        ])
    }

    private func setupLabels() {
        headerLabel.text = "Allow access to scan"
        headerLabel.font = Fonts.SFProDisplay.bold(size: 24.scale) // Custom font
        headerLabel.textColor = Appearance.black // Use Appearance.black
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)

        descriptionLabel.text = "In order to scan anything you need to give permission in settings to choose photos."
        descriptionLabel.font = Fonts.SFProDisplay.medium(size: 16.scale) // Custom font
        descriptionLabel.textColor = Appearance.black.withAlphaComponent(0.6)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 3
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20.scale),
            headerLabel.widthAnchor.constraint(equalToConstant: 358.scale),
            headerLabel.heightAnchor.constraint(equalToConstant: 29.scale),

            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20.scale),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 358.scale),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
    }

    private func setupSettingsAccess() {
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsView)

        NSLayoutConstraint.activate([
            settingsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20.scale),
            settingsView.widthAnchor.constraint(equalToConstant: 260.scale),
            settingsView.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }

    private func setupCameraAccess() {
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)

        NSLayoutConstraint.activate([
            cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraView.topAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: 16.scale),
            cameraView.widthAnchor.constraint(equalToConstant: 260.scale),
            cameraView.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }

    private func setupGoToSettingsButton() {
        goToSettingsButton.setTitle("Go to Settings", for: .normal)
        goToSettingsButton.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17.scale) // Custom font
        goToSettingsButton.backgroundColor = Appearance.signatureBlue
        goToSettingsButton.setTitleColor(Appearance.white, for: .normal) // Use Appearance.white
        goToSettingsButton.layer.cornerRadius = 24.scale
        goToSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToSettingsButton)

        goToSettingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        NSLayoutConstraint.activate([
            goToSettingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToSettingsButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -125.scale : -90.scale),
            goToSettingsButton.widthAnchor.constraint(equalToConstant: 358.scale),
            goToSettingsButton.heightAnchor.constraint(equalToConstant: 66.scale)
        ])
    }

    @objc private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }

    @objc private func requestCameraAccess() {
        // Implement logic to request camera access here
    }
}

class CustomView: UIView {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews(imageName: "SettingsIcon", labelText: "Go to Settings") // Default values
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews(imageName: "SettingsIcon", labelText: "Go to Settings") // Default values
    }
    
    // Specialized initializer
    init(frame: CGRect, imageName: String, labelText: String) {
        super.init(frame: frame)
        setupViews(imageName: imageName, labelText: labelText)
    }
    
    private func setupViews(imageName: String, labelText: String) {
        // Setup the ImageView
        iconImageView.image = UIImage(named: imageName)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Setup the Label
        titleLabel.text = labelText
        titleLabel.textAlignment = .left
        titleLabel.font = Fonts.SFProDisplay.regular(size: 17) // Custom font
        titleLabel.textColor = Appearance.black // Set text color to Appearance.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Define constraints for ImageView
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.scale),
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.scale),
            iconImageView.widthAnchor.constraint(equalToConstant: 40.scale),
            iconImageView.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        // Define constraints for Label
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10.scale),
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200.scale),
            titleLabel.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
    }
}
