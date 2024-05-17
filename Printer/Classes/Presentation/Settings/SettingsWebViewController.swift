//
//  SettingsWebViewController.swift
//  
//
//  Created by Niiaz Khasanov on 5/16/24.
//

import UIKit
import WebKit

class SettingsWebViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    var webView: WKWebView!
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Appearance.mainViewBackground
       
        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.backgroundColor = Appearance.mainViewBackground
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        webView.layer.masksToBounds = true
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Make the navigation bar small
        navigationItem.largeTitleDisplayMode = .never
    }
}
