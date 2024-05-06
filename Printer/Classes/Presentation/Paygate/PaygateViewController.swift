//
//  PaygateViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class PaygateViewController: UIViewController {
    private lazy var mainView =  PaygateView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = PaygateViewModel()
    
    private let didClose: (() -> Void)?
    
    private init(didClose: (() -> Void)?) {
        self.didClose = didClose
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Paygate Screen", parameters: [:])
        
        viewModel.products
            .drive(Binder(self) { base, products in
                base.mainView.leftOptionButton.info = products.first
                base.mainView.rightOptionButton.info = products.last
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.termsOfServiceButton.rx.tap.map { GlobalDefinitions.termsOfUseUrl },
                mainView.privacyPolicyButton.rx.tap.map { GlobalDefinitions.privacyPolicyUrl }
            )
            .bind(to: Binder(self) { base, url in
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
        
        mainView.restoreButton.rx.tap
            .bind(to: viewModel.restore)
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss()
               
            })
            .disposed(by: disposeBag)
        
        Signal
            .merge(
                viewModel.buyed,
                viewModel.restored
            )
            .emit(to: Binder(self) { base, result in
                result ? base.dismiss() : base.showError()
            })
            .disposed(by: disposeBag)
        
        viewModel.activityIndicator
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        mainView.continueButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let id = [
                    base.mainView.leftOptionButton,
                    base.mainView.rightOptionButton
                ].first(where: { $0.isChecked })?.info?.productId
                
                guard let id = id else {
                    return
                }
                
                base.viewModel.buy.accept(id)
            })
            .disposed(by: disposeBag)
        
        mainView.leftOptionButton.isChecked = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension PaygateViewController {
    static func make(didClose: (() -> Void)? = nil) -> PaygateViewController {
        let vc = PaygateViewController(didClose: didClose)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension PaygateViewController {
    func dismiss() {
        dismiss(animated: true) { [weak self] in
            self?.didClose?()
            let tabBarVC = findRootTabBarController()
            tabBarVC?.tabBar.isHidden = false
        }
    }
    
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
        
        mainView.leftOptionButton.isHidden = activity
        mainView.rightOptionButton.isHidden = activity
        mainView.continueButton.isHidden = activity
        mainView.restoreButton.isHidden = activity
    }
    
    func showError() {
        let alert = UIAlertController(title: "Paygate.Error.Title".localized, message: "Paygate.Error.Text".localized, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Paygate.Error.Button".localized, style: .cancel)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
