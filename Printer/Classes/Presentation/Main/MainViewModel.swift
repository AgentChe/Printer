//
//  MainViewModel.swift
//  
//
//  Created by Niiaz Khasanov on 4/29/24.
//
import UIKit

struct QuickAction {
    let title: String
    let detail: String
    let icon: UIImage?
}

final class MainViewModel {
    var quickActions: [QuickAction] = []
    var printerStatus: PrinterStatus?
    
    var onQuickActionsChanged: (([QuickAction]) -> Void)?
    var onPrinterStatusChanged: ((PrinterStatus?) -> Void)?
    
    func loadQuickActions() {
        quickActions = [
            QuickAction(title: NSLocalizedString("MainViewController.Action.Photos", comment: ""),
                        detail: NSLocalizedString("MainViewModel.Action.Photos.Detail", comment: ""),
                        icon: UIImage(named: "QuickActions.Photos")),
            QuickAction(title: NSLocalizedString("MainViewController.Action.Files", comment: ""),
                        detail: NSLocalizedString("MainViewModel.Action.Files.Detail", comment: ""),
                        icon: UIImage(named: "QuickActions.Documents")),
            QuickAction(title: NSLocalizedString("MainViewController.Action.WebPages", comment: ""),
                        detail: NSLocalizedString("MainViewModel.Action.WebPages.Detail", comment: ""),
                        icon: UIImage(named: "QuickActions.Webpages")),
            QuickAction(title: NSLocalizedString("MainViewController.Action.Notes", comment: ""),
                        detail: NSLocalizedString("MainViewModel.Action.Notes.Detail", comment: ""),
                        icon: UIImage(named: "QuickActions.Notes")),
            // Uncomment if needed
            // QuickAction(title: NSLocalizedString("MainViewController.Action.GoogleDrive", comment: ""),
            //             detail: NSLocalizedString("MainViewModel.Action.GoogleDrive.Detail", comment: ""),
            //             icon: UIImage(named: "QuickActions.GoogleDrive")),
            QuickAction(title: NSLocalizedString("MainViewController.Action.Dropbox", comment: ""),
                        detail: NSLocalizedString("MainViewModel.Action.Dropbox.Detail", comment: ""),
                        icon: UIImage(named: "QuickActions.Dropbox")),
            QuickAction(title: NSLocalizedString("MainViewController.Action.Email", comment: ""),
                        detail: NSLocalizedString("MainViewModel.Action.Email.Detail", comment: ""),
                        icon: UIImage(named: "QuickActions.Email")),
            QuickAction(title: NSLocalizedString("MainViewController.Action.TestPrint", comment: ""),
                        detail: NSLocalizedString("MainViewModel.Action.TestPrint.Detail", comment: ""),
                        icon: UIImage(named: "QuickActions.Testprint"))
        ]

        onQuickActionsChanged?(quickActions)
    }
    
    func checkPrinterStatus() {
        printerStatus = PrinterStatus(isConnected: true, name: "Printer N1234")
        onPrinterStatusChanged?(printerStatus)
    }
}
