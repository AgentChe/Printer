//
//  PhotoReviewViewController.swift
//  Printer

import UIKit

class PhotoReviewViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    var capturedImage: UIImage?
    var imageView: UIImageView!
    var keepButton: UIButton!
    var retakeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = Appearance.white // Use Appearance.white
        title = NSLocalizedString("PhotoReview.Title", comment: "Scan")
        
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
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270.scale)  // Adjusting space for buttons
        ])
        
        setupButtons()
    }
    
    private func setupButtons() {
        // Keep button
        keepButton = UIButton(type: .system)
        keepButton.setTitle(NSLocalizedString("PhotoReview.KeepButton", comment: "Keep scan"), for: .normal)
        keepButton.backgroundColor = Appearance.signatureBlue
        keepButton.setTitleColor(Appearance.white, for: .normal) // Use Appearance.white
        keepButton.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17.scale) // Custom font
        keepButton.layer.cornerRadius = 24.scale // Adjust radius to match the one in your image
        keepButton.clipsToBounds = true
        keepButton.translatesAutoresizingMaskIntoConstraints = false
        keepButton.addTarget(self, action: #selector(keepPhoto), for: .touchUpInside)
        view.addSubview(keepButton)
        
        // Retake button
        retakeButton = UIButton(type: .system)
        retakeButton.setTitle(NSLocalizedString("PhotoReview.RetakeButton", comment: "Retake"), for: .normal)
        retakeButton.backgroundColor = .clear // Clear background
        retakeButton.setTitleColor(Appearance.signatureBlue, for: .normal) // Use Appearance.signatureBlue
        retakeButton.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17.scale) // Custom font
        retakeButton.layer.cornerRadius = 0 // No rounded corners
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.addTarget(self, action: #selector(retakePhoto), for: .touchUpInside)
        view.addSubview(retakeButton)
        
        // Constraints for keepButton
        NSLayoutConstraint.activate([
            keepButton.bottomAnchor.constraint(equalTo: retakeButton.topAnchor, constant: -10.scale),
            keepButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.scale),
            keepButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.scale),
            keepButton.heightAnchor.constraint(equalToConstant: 68.scale)
        ])
        
        // Constraints for retakeButton
        NSLayoutConstraint.activate([
            retakeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.scale),
            retakeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.scale),
            retakeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.scale),
            retakeButton.heightAnchor.constraint(equalToConstant: 50.scale)
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
