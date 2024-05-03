//
//  MainViewModel.swift
//  
//
//  Created by Niiaz Khasanov on 4/29/24.
//

import UIKit
struct QuickAction {
    let title: String
    let detail:String
    let icon: UIImage?
}
final class MainViewModel {
    var quickActions: [QuickAction] = []
    var printerStatus: PrinterStatus?
    
    var onQuickActionsChanged: (([QuickAction]) -> Void)?
    var onPrinterStatusChanged: ((PrinterStatus?) -> Void)?
    
    func loadQuickActions() {
        quickActions = [
            QuickAction(title: "Photos", 
                        detail: "Print from gallery",
                        icon: UIImage(named: "QuickActions.Photos")),
            QuickAction(title: "Documents", 
                        detail: "Print PDFs and docs",
                        icon: UIImage(named: "QuickActions.Documents")),
            QuickAction(title: "Web Pages", 
                        detail: "Print from the web",
                        icon: UIImage(named: "QuickActions.Webpages")),
            QuickAction(title: "Notes", 
                        detail: "Print your notes",
                        icon: UIImage(named: "QuickActions.Notes")),
            QuickAction(title: "Google Drive", 
                        detail: "Print from Google Drive",
                        icon: UIImage(named: "QuickActions.GoogleDrive")),
            QuickAction(title: "Dropbox", 
                        detail: "Print from Dropbox",
                        icon: UIImage(named: "QuickActions.Dropbox")),
            QuickAction(title: "Email", 
                        detail: "Print email attachments",
                        icon: UIImage(named: "QuickActions.Email")),
            QuickAction(title: "Test Print", 
                        detail: "Run a test print",
                        icon: UIImage(named: "QuickActions.Testprint"))
        ]

        onQuickActionsChanged?(quickActions)
    }
    
    func checkPrinterStatus() {
        printerStatus = PrinterStatus(isConnected: true, name: "Printer N1234")
        onPrinterStatusChanged?(printerStatus)
    }
}
