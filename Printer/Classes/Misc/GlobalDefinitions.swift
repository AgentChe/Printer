//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "iC30EgiLeN62YD8a"
    
    static let applicationTag = "PRINTER_MANAGER"
    static let amplitudeApiKey = "d433d2c66723aeefd10c5b65f91c1fa3"
    
    static let termsOfUseUrl = URL(string: "https://coffeestop-ou.com/terms.html")!
    static let privacyPolicyUrl = URL(string: "https://coffeestop-ou.com/policy.html")!
    static let contactUsUrl = URL(string: "https://coffeestop-ou.com/contacts.html")!
    
    static let groupId = "group.com.printer.manager"
    
    enum Paygate {
        static let defaultLifetime = "com.printer.manager.lifetime"
        static let defaultMonthly = "com.printer.manager.monthly"
    }
}
