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
        
        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Make the navigation bar small
        navigationItem.largeTitleDisplayMode = .never
    }
}
