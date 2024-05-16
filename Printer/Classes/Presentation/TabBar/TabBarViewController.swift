//
//  TabBarViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 4/30/24.
//

import UIKit

class TabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Initialize all your view controllers
        let mainVC = MainViewController.make()
        let scanVC = ScanViewController()
        let settingsVC = SettingsViewController()
        
        mainVC.tabBarItem = UITabBarItem(
            title: "Print",
            image: resizeImage(image: UIImage(named: "TabBar.Print"), targetSize: CGSize(width: 25, height: 25)),
            tag: 0
        )
        scanVC.tabBarItem = UITabBarItem(
            title: "Scan",
            image: resizeImage(image: UIImage(named: "TabBar.Scan"), targetSize: CGSize(width: 25, height: 25)),
            tag: 1
        )
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: resizeImage(image: UIImage(named: "TabBar.Settings"), targetSize: CGSize(width: 25, height: 25)),
            tag: 2
        )
        
        // Add them as children of the tab bar controller
        self.viewControllers = [
            NavigationController(rootViewController: mainVC),
            scanVC,
            NavigationController(rootViewController: settingsVC)
        ]
        
        // Customizing the Tab Bar's appearance (optional)
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = UIColor.white
        }
        
    }
    func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
