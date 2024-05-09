//
//  BluetoothManager.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/9/24.
//
import CoreBluetooth
 
class BluetoothManager: NSObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    var delegate: StatusChangeDelegate?
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
    }

    // CBCentralManagerDelegate method to monitor changes in the Bluetooth state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is ON")
            delegate?.changeBTHToOn()
        case .poweredOff:
            print("Bluetooth is OFF")
            delegate?.changeBTHToOff()
        case .resetting:
            print("Bluetooth is resetting")
            delegate?.changeBTHToOff()
        case .unauthorized:
            print("Bluetooth is unauthorized")
            delegate?.changeBTHToOff()
        case .unsupported:
            print("Bluetooth is unsupported on this device")
            delegate?.changeBTHToOff()
        case .unknown:
            print("Bluetooth state is unknown")
            delegate?.changeBTHToOff()
        @unknown default:
            print("A new state of Bluetooth that isn't handled")
            delegate?.changeBTHToOff()
        }
    }
}
