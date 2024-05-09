//
//  NetworkManager.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/9/24.
//

import Network

class NetworkMonitor {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    var delegate: StatusChangeDelegate?
    init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied {
                if path.usesInterfaceType(.wifi) {
                    print("Connected via WiFi")
                    delegate?.changeWIFIToOn()
                } else if path.usesInterfaceType(.cellular) {
                    print("Connected via Cellular")
                    delegate?.changeWIFIToOff()
                } else {
                    print("Connected via other networks")
                    delegate?.changeWIFIToOff()
                }
            } else {
                print("No connectivity")
                delegate?.changeWIFIToOff()
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
import SystemConfiguration

class NetworkReachability {
    var delegate: StatusChangeDelegate?
     func isConnectedToWiFi() -> Bool {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com") else {
            delegate?.changeWIFIToOff()
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            delegate?.changeWIFIToOff()
            return false
        }

        let isReachable = flags.contains(.reachable)
        let isOnWWAN = flags.contains(.isWWAN)
        if  isReachable && !isOnWWAN {
            delegate?.changeWIFIToOn()
        }
         if isReachable && isOnWWAN {
             // Connected to the network, but through cellular data, not Wi-Fi
             delegate?.changeWIFIToOff()
             return false
         }
        return isReachable && !isOnWWAN
    }
}
