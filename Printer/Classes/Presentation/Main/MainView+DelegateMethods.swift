//
//  MainView+DelegateMethods.swift
//  Printer
//
//  Created by Niiaz Khasanov on 4/30/24.
//

import UIKit
extension MainView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let parentViewController = parentViewController {
            if let mainViewController = parentViewController as? MainViewController {
                let navigationController = mainViewController.navigationController
                print("CollectionView offset: \(collectionView.contentOffset)")
                let threshold: CGFloat = -94.scale // Or any value that works for your layout
                // Check the offset and adjust the shadow accordingly
                if scrollView.contentOffset.y > threshold {
                    // User has scrolled: show the shadow line
                    if #available(iOS 15.0, *) {
                        
                        let appearance = navigationController?.navigationBar.standardAppearance.copy()
                        appearance?.shadowColor = Appearance.navigationBottomLineColor // Set the shadow color
                        navigationController?.navigationBar.standardAppearance = appearance!
                        navigationController?.navigationBar.scrollEdgeAppearance = appearance!
                    } else {
                        navigationController?.navigationBar.shadowImage = nil // Shows the default shadow line
                    }
                } else {
                    // At the top: hide the shadow line
                    if #available(iOS 15.0, *) {
                        let appearance = navigationController?.navigationBar.standardAppearance.copy()
                        appearance?.shadowColor = nil // Hide the shadow color
                        navigationController?.navigationBar.standardAppearance = appearance!
                        navigationController?.navigationBar.scrollEdgeAppearance = appearance!
                    } else {
                        navigationController?.navigationBar.shadowImage = UIImage() // Hides the shadow line
                    }
                }
            }
        }
    }
}
