//
//  PhotoReviewViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/3/24.
//

import UIKit
class PhotoReviewViewController: UIViewController {
    var capturedImage: UIImage?
    var imageView: UIImageView!
    var keepButton: UIButton!
    var retakeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Scan"
        // Setting up the image view
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = capturedImage
        view.addSubview(imageView)
        
        // Constraints for imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270)  // Adjusting space for buttons
        ])
        
        setupButtons()
    }
    
    private func setupButtons() {
        // Keep button
        keepButton = UIButton(type: .system)
        keepButton.setTitle("Keep scan", for: .normal)
        keepButton.backgroundColor = Appearance.signatureBlue // Set the correct color code if different
        keepButton.setTitleColor(.white, for: .normal)
        keepButton.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17) // Set the font size as needed
        keepButton.layer.cornerRadius = 24 // Adjust radius to match the one in your image
        keepButton.clipsToBounds = true
        keepButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keepButton)
        
        retakeButton = UIButton(type: .system)
        retakeButton.setTitle("Retake", for: .normal)
        retakeButton.backgroundColor = .clear // Clear background
        retakeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        retakeButton.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17) // Adjust the font size as needed
        retakeButton.layer.cornerRadius = 0 // No rounded corners
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(retakeButton)
        
        // Constraints for keepButton
        NSLayoutConstraint.activate([
            keepButton.bottomAnchor.constraint(equalTo: retakeButton.topAnchor, constant: 0),
            keepButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            keepButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            keepButton.heightAnchor.constraint(equalToConstant: 68)
        ])
        
        // Constraints for retakeButton
        NSLayoutConstraint.activate([
            retakeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            retakeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            retakeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            retakeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func keepPhoto() {
        // Logic to save the photo or handle it as needed
        print("Photo kept")
        // Optionally, go back to another view controller or dismiss
    }
    
    @objc func retakePhoto() {
        // Logic to discard the photo and retake it
        navigationController?.popViewController(animated: true)
    }
}
