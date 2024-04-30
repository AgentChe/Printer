//
//  MainViewController.swift
//  Printer
//
//  Created by Андрей Чернышев on 24.04.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private lazy var mainView = MainView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onQuickActionsChanged = { [weak self] actions in
            self?.mainView.quickActions = actions
            self?.mainView.collectionView.reloadData()
        }
        
        viewModel.onPrinterStatusChanged = { [weak self] status in
            self?.mainView.updatePrinterStatus(status)
        }
        
        viewModel.loadQuickActions()
      //  viewModel.checkPrinterStatus()
    }
}

// MARK: Make
extension MainViewController {
    static func make() -> MainViewController {
        MainViewController()
    }
}
