//
//  MainViewController.swift
//  Printer
//
//  Created by Андрей Чернышев on 24.04.2024.
//

import UIKit

final class MainViewController: UIViewController {
    private lazy var mainView = MainView()
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Make
extension MainViewController {
    static func make() -> MainViewController {
        MainViewController()
    }
}
