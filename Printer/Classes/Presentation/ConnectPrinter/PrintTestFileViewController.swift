import UIKit

class PrintTestFileViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    // UI Components
    private let dismissButton = UIButton(type: .system)
    private let imageView = UIImageView()
    private let headerLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let printButton = UIButton(type: .system)
    private let skipButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Appearance.white // Use Appearance.white for background
        setupUI()
    }
    
    private func setupUI() {
        setupDismissButton()
        setupImageView()
        setupLabels()
        setupSkipButton()
        setupPrintButton()
    }

    private func setupSkipButton() {
        skipButton.setTitle(NSLocalizedString("PrintTestFile.SkipButton", comment: "Skip"), for: .normal)
        skipButton.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17.scale)
        skipButton.backgroundColor = .clear
        skipButton.setTitleColor(Appearance.signatureBlue, for: .normal)
        skipButton.layer.cornerRadius = 24.scale
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skipButton)
        
        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
    }

    private func setupDismissButton() {
        let dismissImage = UIImage(named: "SeekForAccess.Dismiss")?.withRenderingMode(.alwaysTemplate)
        dismissButton.setImage(dismissImage, for: .normal)
        dismissButton.tintColor = Appearance.black // Set the color to Appearance.black
        dismissButton.imageView?.contentMode = .scaleAspectFit // Ensure the image is aspect fit
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
        imageView.image = UIImage(named: "Printer.TestPrint") // Ensure this asset is added in your Xcode project
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: ScreenSize.isIphoneXFamily ? 143.scale : 70.scale),
            imageView.widthAnchor.constraint(equalToConstant: 346.scale),
            imageView.heightAnchor.constraint(equalToConstant: 346.scale)
        ])
    }

    private func setupLabels() {
        headerLabel.text = NSLocalizedString("PrintTestFile.Header", comment: "Want to print a test file?")
        headerLabel.font = Fonts.SFProDisplay.bold(size: 24.scale) // Custom font
        headerLabel.textAlignment = .center
        headerLabel.textColor = Appearance.black // Use Appearance.black for header text
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)
        
        descriptionLabel.text = NSLocalizedString("PrintTestFile.Description", comment: "To make sure you have a good connection print a test with this image.")
        descriptionLabel.font = Fonts.SFProDisplay.regular(size: 18.scale) // Custom font
        descriptionLabel.textColor = Appearance.subtitleLabelColor // Use Appearance.subtitleLabelColor
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 3
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 85.scale : 30.scale),
            headerLabel.widthAnchor.constraint(equalToConstant: 358.scale),
            headerLabel.heightAnchor.constraint(equalToConstant: 29.scale),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12.scale),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 358.scale),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }

    @objc private func skipAction() {
        dismiss(animated: true, completion: nil)
    }

    private func setupPrintButton() {
        printButton.setTitle(NSLocalizedString("PrintTestFile.PrintButton", comment: "Print"), for: .normal)
        printButton.titleLabel?.font = Fonts.SFProDisplay.medium(size: 17.scale)
        printButton.backgroundColor = Appearance.signatureBlue // Use Appearance.signatureBlue
        printButton.setTitleColor(Appearance.white, for: .normal) // Use Appearance.white
        printButton.layer.cornerRadius = 24.scale
        printButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(printButton)
        
        printButton.addTarget(self, action: #selector(goToPrintConfigViewController), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -30.0.scale : -10.scale),
            skipButton.widthAnchor.constraint(equalToConstant: 358.scale),
            skipButton.heightAnchor.constraint(equalToConstant: 66.scale)
        ])
        
        NSLayoutConstraint.activate([
            printButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            printButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: ScreenSize.isIphoneXFamily ? -10.scale : 10.scale),
            printButton.widthAnchor.constraint(equalToConstant: 358.scale),
            printButton.heightAnchor.constraint(equalToConstant: 66.scale)
        ])
    }

    @objc private func goToPrintConfigViewController() {
        let textRenderer = CustomPrintTextPageRenderer()
        textRenderer.printText = """
🎉 "Printer" App Test Page 🎉

This is a test page for your printer!

Here are some fun things to print:

1. **A Funny Joke:**
   Why don’t scientists trust atoms?
   Because they make up everything!

2. **Random Fact:**
   Did you know? Honey never spoils. Archaeologists have found pots of honey in ancient Egyptian tombs that are over 3,000 years old and still edible.

3. **A Tongue Twister:**
   How much wood would a woodchuck chuck if a woodchuck could chuck wood?

4. **ASCII Art:**
   (••)
   ( ••)>⌐■-■
   (⌐■_■)

5. **Motivational Quote:**
   "Do or do not, there is no try." - Yoda

6. **Haiku Poem:**
   An old silent pond...
   A frog jumps into the pond,
   splash! Silence again.

Enjoy your printed fun! 😊
"""
        let printOptionsViewController = PrintOptionsViewController()
        printOptionsViewController.textRenderers = [textRenderer]
        present(printOptionsViewController, animated: true)
    }
    
    @objc private func requestCameraAccess() {
        // Implement logic to request camera access here
    }
}
