import UIKit
import WebKit

final class WebViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    private let webView = WKWebView()
    private let toolbar = UIToolbar()
    private let addressTextFieldHeight: CGFloat = 44.0  // Height of the addressTextField

    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter URL"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .URL
        textField.returnKeyType = .go
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(goBack))
        button.isEnabled = false
        return button
    }()
    private lazy var forwardButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(goForward))
        button.isEnabled = false
        return button
    }()
    private lazy var reloadButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadPage))
        return button
    }()
    
    private var toolbarBottomConstraint: NSLayoutConstraint!

    override func loadView() {
        view = UIView()
        view.addSubview(webView)
        view.addSubview(toolbar)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarBottomConstraint = toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.shadowColor = nil
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationController?.navigationBar.isTranslucent = false
        }
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setupToolbar() {
        let addressBar = UIBarButtonItem(customView: addressTextField)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
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
            toolbarBottomConstraint.constant = -keyboardHeight + (ScreenSize.isIphoneXFamily ? addressTextField.frame.height:0)
            
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
        if let urlString = textField.text, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        addressTextField.text = webView.url?.absoluteString
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
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
