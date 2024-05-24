//
//  PrintErrorViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/24/24.
//

import UIKit

class PrintErrorViewController: UIViewController {
    
    // UI Elements
    private let printerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Printer.Question"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.alpha = 0.6
        return button
    }()
    
    private let mainMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong"
        label.font = Fonts.SFProDisplay.bold(size: 24.scale)
        label.textAlignment = .center
        label.textColor = Appearance.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondaryMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Try restarting the printer and try again."
        label.font = Fonts.SFProDisplay.regular(size: 16.scale)
        label.textColor = Appearance.subtitleLabelColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = Appearance.signatureBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24.scale
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Appearance.white
        
        // Add subviews
        view.addSubview(printerImageView)
        view.addSubview(closeButton)
        view.addSubview(mainMessageLabel)
        view.addSubview(secondaryMessageLabel)
        view.addSubview(continueButton)
        
        // Set up constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Close Button
            closeButton.widthAnchor.constraint(equalToConstant: 18.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 20.scale),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.scale),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.scale),
            
            // Printer Image View
            printerImageView.widthAnchor.constraint(equalToConstant: 346.scale),
            printerImageView.heightAnchor.constraint(equalToConstant: 346.scale),
            printerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 143.scale),
            printerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Main Message Label
            mainMessageLabel.topAnchor.constraint(equalTo: printerImageView.bottomAnchor, constant: 20.scale),
            mainMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22.scale),
            mainMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22.scale),
            
            // Secondary Message Label
            secondaryMessageLabel.topAnchor.constraint(equalTo: mainMessageLabel.bottomAnchor, constant: 10.scale),
            secondaryMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22.scale),
            secondaryMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22.scale),
            
            // Continue Button
            continueButton.widthAnchor.constraint(equalToConstant: 358.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 68.scale),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24.scale),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func continueButtonTapped() {
        // Add action for continue button
        dismiss(animated: true, completion: nil)
    }
}
