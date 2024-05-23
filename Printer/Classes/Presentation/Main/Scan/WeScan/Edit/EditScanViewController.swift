//
//  EditScanViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import AVFoundation
import UIKit

/// The `EditScanViewController` offers an interface for the user to edit the detected quadrilateral.
final class EditScanViewController: UIViewController,UIGestureRecognizerDelegate {
    var keepButton: UIButton!
    var retakeButton: UIButton!
    private var filterType: FilterType
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = image
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var quadView: QuadrilateralView = {
        let quadView = QuadrilateralView()
        quadView.editable = true
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()

    private lazy var nextButton: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.edit.button.next",
                                      tableName: nil,
                                      bundle: Bundle(for: EditScanViewController.self),
                                      value: "Next",
                                      comment: "A generic next button"
        )
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(pushReviewController))
        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()

    private lazy var cancelButton: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.scanning.cancel",
                                      tableName: nil,
                                      bundle: Bundle(for: EditScanViewController.self),
                                      value: "Cancel",
                                      comment: "A generic cancel button"
        )
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(cancelButtonTapped))
        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()

    /// The image the quadrilateral was detected on.
    private let image: UIImage

    /// The detected quadrilateral that can be edited by the user. Uses the image's coordinates.
    private var quad: Quadrilateral

    private var zoomGestureController: ZoomGestureController!

    private var quadViewWidthConstraint = NSLayoutConstraint()
    private var quadViewHeightConstraint = NSLayoutConstraint()

    // MARK: - Life Cycle

    init(image: UIImage, quad: Quadrilateral?, rotateImage: Bool = true, filterType: FilterType = .adaptiveThreshold) {
        self.image = rotateImage ? image.applyingPortraitOrientation() : image
        self.quad = quad ?? EditScanViewController.defaultQuad(forImage: image)
        self.filterType = filterType
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        // Customize the back button
       
        navigationController?.navigationBar.tintColor = Appearance.signatureBlue // Change to your preferred color
        
       
        
        // Create a UINavigationBarAppearance instance
          let appearance = UINavigationBarAppearance()
          appearance.backgroundColor = Appearance.white  // Customize the background color if needed
        appearance.titleTextAttributes = [.foregroundColor: Appearance.signatureBlue]  // Set title color here
          
          // Apply the appearance to the navigation bar
          navigationController?.navigationBar.standardAppearance = appearance
          if #available(iOS 15.0, *) {
              navigationController?.navigationBar.scrollEdgeAppearance = appearance
          }
        
        
        title = NSLocalizedString("wescan.edit.title",
                                  tableName: nil,
                                  bundle: Bundle(for: EditScanViewController.self),
                                  value: "Scan",
                                  comment: "The title of the EditScanViewController"
        )
      
        //navigationItem.rightBarButtonItem = nextButton
        if let firstVC = self.navigationController?.viewControllers.first, firstVC == self {
            navigationItem.leftBarButtonItem = cancelButton
        } else {
            navigationItem.leftBarButtonItem = nil
        }

        zoomGestureController = ZoomGestureController(image: image, quadView: quadView)

        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.minimumPressDuration = 0
        touchDown.delegate = self
        view.addGestureRecognizer(touchDown)
    }
    
    // MARK: - Setups
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(quadView)
        setupButtons() // Include buttons in the setup.
        
    }

    private func setupButtons() {
        // Keep button
        keepButton = UIButton(type: .system)
        keepButton.setTitle("Keep scan", for: .normal)
        keepButton.backgroundColor = Appearance.signatureBlue // Using your custom color
        keepButton.setTitleColor(.white, for: .normal)
        keepButton.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17) // Using your custom font
        keepButton.layer.cornerRadius = 24 // Adjust radius to match the one in your image.
        keepButton.clipsToBounds = true
        keepButton.translatesAutoresizingMaskIntoConstraints = false
        keepButton.addTarget(self, action: #selector(keepButtonTapped), for: .touchUpInside)

        view.addSubview(keepButton)

        // Retake button
        retakeButton = UIButton(type: .system)
        retakeButton.setTitle("Retake", for: .normal)
        retakeButton.backgroundColor = .clear // Clear background
        retakeButton.setTitleColor(UIColor.systemBlue, for: .normal)
        retakeButton.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17) // Using your custom font
        retakeButton.layer.cornerRadius = 0 // No rounded corners
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.addTarget(self, action: #selector(retakeButtonTapped), for: .touchUpInside)
        view.addSubview(retakeButton)
    }
    @objc func retakeButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func keepButtonTapped() {
        guard let quad = quadView.quad,
            let ciImage = CIImage(image: image) else {
                if let imageScannerController = navigationController as? ImageScannerController {
                    let error = ImageScannerControllerError.ciImageCreation
                    imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
                }
                return
        }
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        let scaledQuad = quad.scale(quadView.bounds.size, image.size)
        self.quad = scaledQuad

        // Cropped Image
        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: image.size.height)
        cartesianScaledQuad.reorganize()

        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
        ])

        var finalImage: UIImage? = UIImage.from(ciImage: filteredImage)

        switch filterType {
        case .none:
            break
        case .grayscale:
            finalImage = filteredImage.applyingGrayscaleFilter()
        case .adaptiveThreshold:
            finalImage = filteredImage.applyingAdaptiveThreshold()
        }

        let enhancedScan = finalImage.flatMap { ImageScannerScan(image: $0) }

        let results = ImageScannerResults(
            detectedRectangle: scaledQuad,
            originalScan: ImageScannerScan(image: image),
            croppedScan: ImageScannerScan(image: finalImage ?? UIImage()),
            enhancedScan: enhancedScan
        )
        ImageManager.shared.addImageScans(results)
        self.navigationController?.popViewController(animated: true)
    }

    private func setupConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: ScreenSize.isIphoneXFamily ? -150.scale:-100.scale),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ]

        quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
        quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)

        let quadViewConstraints = [
            quadView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            quadView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            quadViewWidthConstraint,
            quadViewHeightConstraint
        ]

        NSLayoutConstraint.activate(quadViewConstraints + imageViewConstraints)

        // Constraints for keepButton
        NSLayoutConstraint.activate([
            keepButton.bottomAnchor.constraint(equalTo: retakeButton.topAnchor, constant:ScreenSize.isIphoneXFamily ? -10.scale:-5.scale), // Distance between buttons.
            keepButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale:40.scale),
            keepButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:ScreenSize.isIphoneXFamily ? -20.scale:-40.scale),
            keepButton.heightAnchor.constraint(equalToConstant:  ScreenSize.isIphoneXFamily ? 68.scale:50.scale)
        ])

        // Constraints for retakeButton
        NSLayoutConstraint.activate([
            retakeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -40.scale:-10.scale), // Lifted up by 10 pts
            retakeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale:40.scale),
            retakeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ScreenSize.isIphoneXFamily ? -20.scale:-40.scale),
            retakeButton.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 50.scale:30.scale)
        ])
        
    }
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Check if the touch is inside the keepButton or retakeButton
        if touch.view == keepButton || touch.view == retakeButton {
            return false
        }
        return true
    }
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustQuadViewConstraints()
        displayQuad()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Work around for an iOS 11.2 bug where UIBarButtonItems don't get back to their normal state after being pressed.
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
        let tabBarVC = findRootTabBarController()
        tabBarVC?.tabBar.isHidden = false
    }

  


    // MARK: - Actions
    @objc func cancelButtonTapped() {
        if let imageScannerController = navigationController as? ImageScannerController {
            imageScannerController.imageScannerDelegate?.imageScannerControllerDidCancel(imageScannerController)
        }
    }

    @objc func pushReviewController() {
        guard let quad = quadView.quad,
            let ciImage = CIImage(image: image) else {
                if let imageScannerController = navigationController as? ImageScannerController {
                    let error = ImageScannerControllerError.ciImageCreation
                    imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
                }
                return
        }
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        let scaledQuad = quad.scale(quadView.bounds.size, image.size)
        self.quad = scaledQuad

        // Cropped Image
        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: image.size.height)
        cartesianScaledQuad.reorganize()

        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
        ])

        var finalImage: UIImage? = UIImage.from(ciImage: filteredImage)

        switch filterType {
        case .none:
            break
        case .grayscale:
            finalImage = filteredImage.applyingGrayscaleFilter()
        case .adaptiveThreshold:
            finalImage = filteredImage.applyingAdaptiveThreshold()
        }

        let enhancedScan = finalImage.flatMap { ImageScannerScan(image: $0) }

        let results = ImageScannerResults(
            detectedRectangle: scaledQuad,
            originalScan: ImageScannerScan(image: image),
            croppedScan: ImageScannerScan(image: finalImage ?? UIImage()),
            enhancedScan: enhancedScan
        )
        ImageManager.shared.addImageScans(results)
        let reviewViewController = ReviewViewController(results: results)
        navigationController?.pushViewController(reviewViewController, animated: true)
    }


    private func displayQuad() {
        let imageSize = image.size
        let imageFrame = CGRect(
            origin: quadView.frame.origin,
            size: CGSize(width: quadViewWidthConstraint.constant, height: quadViewHeightConstraint.constant)
        )

        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedQuad = quad.applyTransforms(transforms)

        quadView.drawQuadrilateral(quad: transformedQuad, animated: false)
    }

    /// The quadView should be lined up on top of the actual image displayed by the imageView.
    /// Since there is no way to know the size of that image before run time, we adjust the constraints
    /// to make sure that the quadView is on top of the displayed image.
    private func adjustQuadViewConstraints() {
        let frame = AVMakeRect(aspectRatio: image.size, insideRect: imageView.bounds)
        quadViewWidthConstraint.constant = frame.size.width
        quadViewHeightConstraint.constant = frame.size.height
    }

    /// Generates a `Quadrilateral` object that's centered and 90% of the size of the passed in image.
    private static func defaultQuad(forImage image: UIImage) -> Quadrilateral {
        let topLeft = CGPoint(x: image.size.width * 0.05, y: image.size.height * 0.05)
        let topRight = CGPoint(x: image.size.width * 0.95, y: image.size.height * 0.05)
        let bottomRight = CGPoint(x: image.size.width * 0.95, y: image.size.height * 0.95)
        let bottomLeft = CGPoint(x: image.size.width * 0.05, y: image.size.height * 0.95)

        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)

        return quad
    }

}
