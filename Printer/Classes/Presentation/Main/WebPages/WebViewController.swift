import UIKit
import WebKit

final class WebViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    private let webView = WKWebView()
    private let toolbar = UIToolbar()
    private let addressTextFieldHeight: CGFloat = 37.0  // Height of the addressTextField
    private let addressTextFieldWidth: CGFloat = 270.0  // Desired width for the addressTextField

    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter URL or search query"
        textField.backgroundColor = Appearance.white  // Set background color to Appearance.white
        textField.textColor = Appearance.black  // Set text color to Appearance.black
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .URL
        textField.returnKeyType = .go
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Set corner radius and shadow
        textField.layer.cornerRadius = 15
        textField.layer.shadowColor = Appearance.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowOpacity = 0.15
        textField.layer.shadowRadius = 4
        textField.layer.masksToBounds = false
        
        // Add padding inside the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.resized(to: CGSize(width: 16, height: 20)), style: .plain, target: self, action: #selector(goBack))
        button.tintColor = webView.canGoBack ? Appearance.signatureBlue : .gray
        return button
    }()
    
    private lazy var forwardButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.right")?.resized(to: CGSize(width: 16, height: 20)), style: .plain, target: self, action: #selector(goForward))
        button.tintColor = webView.canGoForward ? Appearance.signatureBlue : .gray
        return button
    }()
    
    private lazy var reloadButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise")?.resized(to: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(reloadPage))
        return button
    }()
    
    private var toolbarBottomConstraint: NSLayoutConstraint!
    private var toolbarHeightConstraint: NSLayoutConstraint!

    override func loadView() {
        view = UIView()
        view.addSubview(webView)
        view.addSubview(toolbar)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarBottomConstraint = toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        let toolbarHeight: CGFloat = 55.0
        
        toolbarHeightConstraint = toolbar.heightAnchor.constraint(equalToConstant: toolbarHeight)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarHeightConstraint,
            toolbarBottomConstraint
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        setupNavigationBar()
        setupToolbar()
        loadInitialWebPage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupNavigationBar() {
        title = "Web Pages"
        navigationItem.largeTitleDisplayMode = .never
        let printButton = UIBarButtonItem(image: UIImage(named: "PrinterCell.Printer")?.resized(to: CGSize(width: 24, height: 24)), style: .plain, target: self, action: #selector(printWebPage))
        navigationItem.rightBarButtonItem = printButton
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Appearance.mainViewBackground
            appearance.titleTextAttributes = [.foregroundColor: Appearance.black]
            appearance.shadowColor = nil
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = Appearance.white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Appearance.black]
            navigationController?.navigationBar.isTranslucent = false
        }
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setupToolbar() {
        toolbar.backgroundColor = Appearance.mainViewBackground // Set toolbar background color
        let addressBar = UIBarButtonItem(customView: addressTextField)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        NSLayoutConstraint.activate([
            addressTextField.widthAnchor.constraint(equalToConstant: addressTextFieldWidth),
            addressTextField.heightAnchor.constraint(equalToConstant: addressTextFieldHeight)
        ])
        
        toolbar.items = [backButton, forwardButton, flexibleSpace, addressBar, flexibleSpace, reloadButton]
    }
    
    private func loadInitialWebPage() {
        let urlString = "https://www.apple.com" // Change this to the URL you want to load initially
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
            addressTextField.text = urlString
        }
    }
    
    @objc private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc private func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc private func reloadPage() {
        webView.reload()
    }
    
    @objc private func printWebPage() {
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printInfo.jobName = "Print Web Page"
        printController.printInfo = printInfo
        printController.printFormatter = webView.viewPrintFormatter()
        printController.present(animated: true, completionHandler: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            
            let keyboardHeight = keyboardFrame.height
            toolbarBottomConstraint.constant = -keyboardHeight + (UIDevice.current.userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height >= 2436) ? addressTextField.frame.height : 0)
            
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16), animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            
            toolbarBottomConstraint.constant = 0
            
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16), animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let urlString = textField.text {
            processAddressInput(urlString)
        }
        textField.resignFirstResponder()
        return true
    }
    
    private func processAddressInput(_ input: String) {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedInput.contains(".com") {
            var urlString = trimmedInput
            
            if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
                urlString = "https://" + urlString
            }
            
            if let url = URL(string: urlString) {
                loadURL(url)
            }
        } else {
            performGoogleSearch(query: trimmedInput)
        }
    }
    
    private func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func performGoogleSearch(query: String) {
        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let searchURL = URL(string: "https://www.google.com/search?q=\(searchQuery)") {
            loadURL(searchURL)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        addressTextField.text = webView.url?.absoluteString
        backButton.tintColor = webView.canGoBack ? Appearance.signatureBlue : .gray
        forwardButton.tintColor = webView.canGoForward ? Appearance.signatureBlue : .gray
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
