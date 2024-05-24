//
//  SceneDelegate+ActionExtension.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/24/24.
//

import UIKit
import SwiftyDropbox

extension SceneDelegate {
    func printFile(at url: URL) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.niiaz.khasanov.group") else {
            print("Failed to get container URL")
            return
        }
        let fileURL = containerURL.appendingPathComponent(url.lastPathComponent)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("File does not exist at URL: \(fileURL)")
            return
        }
         
        do {
            let data = try Data(contentsOf: fileURL)
            let pathExtension = fileURL.pathExtension.lowercased()
            print("File path extension: \(pathExtension)")
            
            switch pathExtension {
            case "pdf":
                printPDF(data: data, fileURL: fileURL)
            case "txt", "swift", "md", "note": // Add more text-based extensions here
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                printText(text)
            case "docx":
                printDocx(data)
            case "html":
                let html = try String(contentsOf: fileURL, encoding: .utf8)
                
                printHTML(html)
            default:
                printImage(data: data, fileURL: fileURL)
            }
            
        } catch {
            print("Error loading data from URL: \(fileURL), error: \(error)")
        }
    }
    func printHTML(_ html: String) {
        NSLog("Printing HTML content")
        
        let printController = UIPrintInteractionController.shared

        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printController.printInfo = printInfo

        let format = UIMarkupTextPrintFormatter(markupText: html)

        format.perPageContentInsets.top = 72
        format.perPageContentInsets.bottom = 72
        format.perPageContentInsets.left = 72
        format.perPageContentInsets.right = 72
        printController.printFormatter = format

        printController.present(animated: true, completionHandler: nil)
    }
    func printPDF(data: Data, fileURL: URL) {
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = fileURL.lastPathComponent
        printInfo.outputType = .general
        printController.printInfo = printInfo
        printController.printingItem = data
        printController.present(animated: true) { (controller, completed, error) in
            if completed {
                print("Print completed successfully.")
            } else {
                if let error = error {
                    print("Failed to print: \(error.localizedDescription)")
                } else {
                    print("Print was cancelled.")
                }
            }
        }
    }
    func printImage(data: Data, fileURL: URL) {
        guard let image = UIImage(data: data) else {
            print("Failed to create image from data at URL: \(fileURL)")
            return
        }
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = fileURL.lastPathComponent
        printInfo.outputType = .photo
        printController.printInfo = printInfo
        printController.printingItem = image
        printController.present(animated: true) { (controller, completed, error) in
            if completed {
                print("Print completed successfully.")
            } else {
                if let error = error {
                    print("Failed to print: \(error.localizedDescription)")
                } else {
                    print("Print was cancelled.")
                }
            }
        }
    }
    func printData(_ data: Data) {
        // Implement data printing logic
        print("Printing data")
        // e.g., present UIPrintInteractionController with the data
    }
    func printText(_ text: String) {
        let textWithNewCarriageReturns = text.replacingOccurrences(of: "\n", with: "<br />")

        let printController = UIPrintInteractionController.shared

        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printController.printInfo = printInfo

        let format = UIMarkupTextPrintFormatter(markupText: textWithNewCarriageReturns)

        format.perPageContentInsets.top = 72
        format.perPageContentInsets.bottom = 72
        format.perPageContentInsets.left = 72
        format.perPageContentInsets.right = 72
        printController.printFormatter = format

        printController.present(animated: true, completionHandler: nil)
    }
    func printDocx(_ data: Data) {
        let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("docx")
        do {
            try data.write(to: tempFileURL)
            let printController = UIPrintInteractionController.shared
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = tempFileURL.lastPathComponent
            printInfo.outputType = .general
            printController.printInfo = printInfo
            printController.printingItem = tempFileURL
            printController.present(animated: true) { (controller, completed, error) in
                if completed {
                    print("Print completed successfully.")
                } else {
                    if let error = error {
                        print("Failed to print: \(error.localizedDescription)")
                    } else {
                        print("Print was cancelled.")
                    }
                }
                try? FileManager.default.removeItem(at: tempFileURL)
            }
        } catch {
            print("Error writing DOCX data to temporary file: \(error.localizedDescription)")
        }
    }
}
