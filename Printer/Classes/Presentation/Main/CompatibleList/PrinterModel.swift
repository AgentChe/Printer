//
//  PrinterModel.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/16/24.
//

import Foundation

struct PrinterModel {
    let brand: String
    let models: [String]
}

class PrinterData {
    var printers: [PrinterModel] = []

    init(fileName: String) {
        loadPrinters(from: fileName)
    }

    private func loadPrinters(from fileName: String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt"),
           let content = try? String(contentsOfFile: path) {
            let lines = content.split(separator: "\n").map { String($0) }
            var brandModels: [String: [String]] = [:]
            
            for line in lines {
                let components = line.split(separator: " ", maxSplits: 1)
                if components.count == 2 {
                    let brand = String(components[0])
                    let model = String(components[1])
                    brandModels[brand, default: []].append(model)
                }
            }
            
            for (brand, models) in brandModels {
                let printerModel = PrinterModel(brand: brand, models: models)
                printers.append(printerModel)
            }
        }
    }
}
