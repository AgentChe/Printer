//
//  UIView.swift
//  Printer
//
//  Created by Niiaz Khasanov on 4/30/24.
//

import UIKit
extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}
