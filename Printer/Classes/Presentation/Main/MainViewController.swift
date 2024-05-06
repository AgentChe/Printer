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
        // Set the title of the navigation item
        title = "My printer"
          
           // Enable large titles
           navigationController?.navigationBar.prefersLargeTitles = true
           navigationItem.largeTitleDisplayMode = .always

           // Style the navigation bar for iOS 15 and later
           if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
               appearance.backgroundColor = Appearance.mainViewBackground
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // Large title color
               appearance.shadowColor = nil

                // Set the appearance for when the view controller is shown
                navigationController?.navigationBar.standardAppearance = appearance
                // Set the appearance for when the view controller is scrolled
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
            } else {
                // Style the navigation bar for earlier iOS versions
                navigationController?.navigationBar.barTintColor = .white
                navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
                navigationController?.navigationBar.isTranslucent = false
                navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // Large title color
            }
        // Remove the shadow line for all versions
         navigationController?.navigationBar.shadowImage = UIImage()
         // Set the navigation bar's background image to a blank/empty image
         navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         
      
        
        viewModel.onQuickActionsChanged = { [weak self] actions in
            self?.mainView.quickActions = actions
            self?.mainView.collectionView.reloadData()
        }
        
        viewModel.onPrinterStatusChanged = { [weak self] status in
         //   self?.mainView.updatePrinterStatus(status)
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
