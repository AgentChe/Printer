//
//  ScanViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/3/24.
//
import UIKit
import AVFoundation

class ScanViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureButton: UIButton!
    var photoOutput = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupCaptureButton()
        setupNavigationBar()
    }
    private func setupNavigationBar() {
        guard let navigationController = self.navigationController else { return }

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController.navigationBar.standardAppearance = navBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController.navigationBar.compactAppearance = navBarAppearance
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.shadowImage = UIImage()

        // Lightning Button Setup
        let lightningButton = UIButton(type: .custom)
        if let image = UIImage(named: "Scan.Lightning") {
            lightningButton.setImage(image, for: .normal)
            lightningButton.imageView?.contentMode = .scaleAspectFit
            lightningButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Adjust padding to resize image
        }
        lightningButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        lightningButton.addTarget(self, action: #selector(lightningButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: lightningButton)

        // Filter Button Setup as Title View
        let filterButton = UIButton(type: .custom)
        if let image = UIImage(named: "Scan.Filters") {
            filterButton.setImage(image, for: .normal)
            filterButton.imageView?.contentMode = .scaleAspectFit
            filterButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Adjust padding to resize image
        }
        filterButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        filterButton.frame = titleView.bounds
        titleView.addSubview(filterButton)
        navigationItem.titleView = titleView

        // "Auto" Button Setup
        let autoButton = UIButton(type: .system)
        autoButton.setTitle("Auto", for: .normal)
        autoButton.setTitleColor(.blue, for: .normal)
        autoButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        autoButton.addTarget(self, action: #selector(autoButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: autoButton)
    }

    @objc func lightningButtonTapped() {
        // Implement what happens when the lightning button is tapped
    }

    @objc func filterButtonTapped() {
        // Implement what happens when the filter button is tapped
    }

    @objc func autoButtonTapped() {
        // Implement what happens when the 'Auto' button is tapped
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCameraPermissions()
    }

    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.startCamera()
                    }
                }
            }
        default:
            // Handle case where user has denied permission
            print("Camera access denied")
        }
    }

    private func startCamera() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if self.captureSession?.isRunning == false {
                self.captureSession.startRunning()
                DispatchQueue.main.async {
                    self.setupPreviewLayer()
                }
            }
        }
    }

    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
 
    private func setupCaptureButton() {
        captureButton = UIButton()
        captureButton.setImage(UIImage(named: "Scan.Capture"), for: .normal) // Use your actual image asset name
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        captureButton.backgroundColor = .clear // Optional
        captureButton.layer.cornerRadius = 35 // Half of height and width if button is 70x70

        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)

        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.scale),
            captureButton.widthAnchor.constraint(equalToConstant: 66.scale),
            captureButton.heightAnchor.constraint(equalToConstant: 66.scale)
        ])
    }


    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
}

extension ScanViewController: AVCapturePhotoCaptureDelegate {
    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        displayCapturedPhoto(capturedImage: image)
    }

    private func displayCapturedPhoto(capturedImage: UIImage) {
        let photoReviewController = PhotoReviewViewController()
        photoReviewController.capturedImage = capturedImage
        photoReviewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(photoReviewController, animated: true)
    }
}

 
