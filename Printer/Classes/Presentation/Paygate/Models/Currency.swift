//
//  Currency.swift
//  Printer
//
//  Created by Андрей Чернышев on 24.04.2024.
//

import Foundation

struct Currency {
    enum LTRCurrency: String, CaseIterable {
        case USD = "USD"
    }
    
    private let productPrice: ProductPrice
    private let div: Double
    
    init(productPrice: ProductPrice, div: Double = 1) {
        self.productPrice = productPrice
        self.div = div
    }
    
    func formatted() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = productPrice.priceLocale
        formatter.roundingMode = .down
        formatter.currencyCode = productPrice.currency
        
        let currencySymbol = formatter.currencySymbol ?? productPrice.currency
        
        formatter.currencyCode = ""
        formatter.currencySymbol = ""
        
        if div == 1 {
            let result = productPrice.priceLocalized.replacingOccurrences(of: currencySymbol, with: "")
            return localized(price: result, currencySymbol: currencySymbol)
        }
        
        let resultPrice = productPrice.priceValue / Double(div)
        
        if resultPrice < 100 {
            formatter.maximumFractionDigits = 2
        } else if resultPrice < 1000 {
            formatter.maximumFractionDigits = 1
        } else {
            formatter.maximumFractionDigits = 0
        }
        
        guard let result = formatter.string(from: NSNumber(value: resultPrice)) else {
            return nil
        }
        
        return localized(price: result, currencySymbol: currencySymbol)
    }
    
    private func localized(price: String, currencySymbol: String) -> String {
        let ltrCurrencies = LTRCurrency.allCases.map { $0.rawValue }
        
        let result: String
        if ltrCurrencies.contains(productPrice.currency) {
            result = String(format: "%@%@", currencySymbol, price)
        } else {
            result = String(format: "%@%@", price, currencySymbol)
        }
        
        return result
            .removingWhitespaces()
    }
}
