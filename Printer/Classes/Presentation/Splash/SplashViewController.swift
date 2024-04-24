//
//  SplashViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

final class SplashViewController: UIViewController {
    private lazy var mainView = SplashView()
    
    private lazy var sdkInitialize = SplashReceiptValidationObserver()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sdkInitialize.observe { [weak self] in
            self?.route()
        }
    }
}

// MARK: Make
extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}

// MARK: Private
private extension SplashViewController {
    func route() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.goNext()
        }
    }
    
    func goNext() {
        guard OnboardingViewController.wasViewed() else {
            UIApplication.shared.keyWindow?.rootViewController = OnboardingViewController.make()
            return
        }
        
        let nc = NavigationController(rootViewController: MainViewController.make())
        nc.setNavigationBarHidden(true, animated: false)
        
        if SessionManager().hasActiveSubscriptions() {
            UIApplication.shared.keyWindow?.rootViewController = nc
        } else {
            let vc = PaygateViewController.make {
                UIApplication.shared.keyWindow?.rootViewController = nc
            }
            present(vc, animated: true)
        }
    }
}
