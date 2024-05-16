//
//  SettingsViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 4/30/24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var tableView: UITableView!
    
    // Assuming you have these settings somewhere
    let settingsOptions = ["Contact us", "Terms of Use", "Privacy Policy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Appearance.mainViewBackground
        title = "Settings"
        
        // Enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Style the navigation bar for iOS 15 and later
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Appearance.mainViewBackground
            appearance.titleTextAttributes = [.foregroundColor: Appearance.black]
            appearance.largeTitleTextAttributes = [.foregroundColor: Appearance.black] // Large title color
            appearance.shadowColor = nil
            
            // Set the appearance for when the view controller is shown
            navigationController?.navigationBar.standardAppearance = appearance
            // Set the appearance for when the view controller is scrolled
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            // Style the navigation bar for earlier iOS versions
            navigationController?.navigationBar.barTintColor = Appearance.white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Appearance.black]
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Appearance.black] // Large title color
        }
        // Remove the shadow line for all versions
        navigationController?.navigationBar.shadowImage = UIImage()
        // Set the navigation bar's background image to a blank/empty image
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalToConstant: 358.scale),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.backgroundColor = Appearance.mainViewBackground
        tableView.dataSource = self
        tableView.delegate = self
        
        // Additional tableView styling
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.scale // Set the height of each cell to 64 points
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.textLabel?.text = settingsOptions[indexPath.row]
        cell.textLabel?.textColor = Appearance.black // Use Appearance.black
        cell.backgroundColor = Appearance.white // Use Appearance.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Cast the cell to your custom cell class
        guard let cell = cell as? SettingsTableViewCell else { return }
        
        // Round the appropriate corners based on position in the table
        if indexPath.row == 0 {
            // First cell, round top corners
            cell.roundCorners(top: true, bottom: false)
        } else if indexPath.row == settingsOptions.count - 1 {
            // Last cell, round bottom corners
            cell.roundCorners(top: false, bottom: true)
        } else {
            // Middle cells, no rounding
            cell.roundCorners(top: false, bottom: false)
        }
        
        if indexPath.row == 0 || indexPath.row == 1 {
            cell.showSeparator()
        } else {
            cell.hideSeparator()
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let settingsWebViewController = SettingsWebViewController()
        
        switch indexPath.row {
        case 0:
            // Contact us action
            settingsWebViewController.url = GlobalDefinitions.contactUsUrl
        case 1:
            // Terms of Use action
            settingsWebViewController.url = GlobalDefinitions.termsOfUseUrl
        case 2:
            // Privacy Policy action
            settingsWebViewController.url = GlobalDefinitions.privacyPolicyUrl
        default:
            return
        }
        
        navigationController?.pushViewController(settingsWebViewController, animated: true)
    }
}
