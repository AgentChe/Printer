//
//  ConnectPrinterViewController.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/9/24.
//

import UIKit
protocol StatusChangeDelegate: AnyObject {
    func changeWIFIToOn()
    func changeWIFIToOff()
    func changeBTHToOn()
    func changeBTHToOff()
}
class ConnectPrinterViewController: UIViewController,StatusChangeDelegate {
    
    
    
    // Create the header label
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Check your connection"
        label.font = Fonts.SFProDisplay.bold(size: 24) //UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    // Create the detail label
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Make sure your phone and printer are connected to the same Wi-Fi network or bluetooth turned on for both devices"
        label.font = Fonts.SFProDisplay.medium(size: 15)//UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        label.textAlignment = .left
        label.numberOfLines = 4  // Allow multiple lines
        return label
    }()
    
    // Create the 'x' button
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let closeImage = UIImage(named: "SeekForAccess.Dismiss")?.withRenderingMode(.alwaysTemplate)
        button.setImage(closeImage, for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .right
        return button
    }()
    let bluetoothToggleView: BluetoothToggleView = {
        let view = BluetoothToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let wifiToggleView: WifiToggleView = {
        let view = WifiToggleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let addPrinterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New printer", for: .normal)
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 16)
        button.backgroundColor = Appearance.signatureBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Move title label 2 points up
        button.titleEdgeInsets = UIEdgeInsets(top: -1.7.scale, left: 0, bottom: 0, right: 0)
        
        return button
    }()
    let availablePrintersLabel: UILabel = {
          let label = UILabel()
          label.text = "Available Printers"
          label.font = Fonts.SFProDisplay.bold(size: 24) // Assuming the font and size from your description
          label.textColor = .black
          label.textAlignment = .left
          return label
      }()
    let instructionLabel: UILabel = {
           let label = UILabel()
           label.text = "If you don’t see your printer here, please check the connections and reboot it (power reset) and try again."
           label.font = Fonts.SFProDisplay.medium(size: 15)
           label.textColor = .gray
           label.numberOfLines = 3
           label.textAlignment = .left
           return label
       }()
       
       let showCompatiblePrinterListButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Printer compatible list", for: .normal)
           button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 16)
           button.backgroundColor = .clear
           button.contentHorizontalAlignment = .left
           button.setTitleColor(.systemBlue, for: .normal)
           return button
       }()
    var connectionCheckTimer: Timer?
    let wifi2ndManager = NetworkReachability()
    let bluetoothManager = BluetoothManager()
    func setupConnectionCheckTimer() {
        connectionCheckTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkWiFiConnection), userInfo: nil, repeats: true)
    }
    @objc func checkWiFiConnection() {
        if wifi2ndManager.isConnectedToWiFi() {
            changeWIFIToOn()
        } else {
            changeWIFIToOff()
        }
    }
    deinit {
        connectionCheckTimer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Appearance.mainViewBackground
        setupViews()
        
        wifi2ndManager.delegate = self
        
        bluetoothManager.delegate = self
        
        setupConnectionCheckTimer()
    }
    func changeWIFIToOn() {
        wifiToggleView.updateSwitchImage(with: "ToggleView.SwitchOn")
    }
    
    func changeWIFIToOff() {
        wifiToggleView.updateSwitchImage(with: "ToggleView.SwitchOff")
    }
    
    func changeBTHToOn() {
        bluetoothToggleView.updateSwitchImage(with: "ToggleView.SwitchOn")
    }
    
    func changeBTHToOff() {
        bluetoothToggleView.updateSwitchImage(with: "ToggleView.SwitchOff")
    }
    
    private func setupViews() {
        view.addSubview(headerLabel)
        view.addSubview(detailLabel)
        view.addSubview(closeButton)
        view.addSubview(bluetoothToggleView)
        view.addSubview(wifiToggleView)
        view.addSubview(addPrinterButton)
        view.addSubview(availablePrintersLabel)
        view.addSubview(instructionLabel)
        view.addSubview(showCompatiblePrinterListButton)
        
        // Use AutoLayout to position the views
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        bluetoothToggleView.translatesAutoresizingMaskIntoConstraints = false
        wifiToggleView.translatesAutoresizingMaskIntoConstraints = false
        availablePrintersLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        showCompatiblePrinterListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.scale),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.scale),
            closeButton.widthAnchor.constraint(equalToConstant: 17.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 17.scale),
            
            headerLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20.scale),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.scale),
            headerLabel.widthAnchor.constraint(equalToConstant: 270.scale),
            headerLabel.heightAnchor.constraint(equalToConstant: 29.scale),
            
            detailLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20.scale),
            detailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.scale),
            detailLabel.widthAnchor.constraint(equalToConstant: 358.scale),
            detailLabel.heightAnchor.constraint(equalToConstant: 64.scale),
            
            bluetoothToggleView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 20.scale),
            bluetoothToggleView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.scale),
            bluetoothToggleView.widthAnchor.constraint(equalToConstant: 358.scale),
            bluetoothToggleView.heightAnchor.constraint(equalToConstant: 79.scale),
            
            wifiToggleView.topAnchor.constraint(equalTo: bluetoothToggleView.bottomAnchor, constant: 20.scale),
            wifiToggleView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.scale),
            wifiToggleView.widthAnchor.constraint(equalToConstant: 358.scale),
            wifiToggleView.heightAnchor.constraint(equalToConstant: 79.scale),
            
            addPrinterButton.topAnchor.constraint(equalTo: wifiToggleView.bottomAnchor, constant: 32.scale),
            addPrinterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPrinterButton.widthAnchor.constraint(equalToConstant: 144.scale),
            addPrinterButton.heightAnchor.constraint(equalToConstant: 50.scale),
            
           
            availablePrintersLabel.topAnchor.constraint(equalTo: addPrinterButton.bottomAnchor, constant: 25.scale),
            availablePrintersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.scale),
            availablePrintersLabel.widthAnchor.constraint(equalToConstant: 270.scale),
            availablePrintersLabel.heightAnchor.constraint(equalToConstant: 29.scale),

            instructionLabel.topAnchor.constraint(equalTo: availablePrintersLabel.bottomAnchor, constant: 10.scale),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.scale),
            instructionLabel.widthAnchor.constraint(equalToConstant: 348.scale),
            instructionLabel.heightAnchor.constraint(equalToConstant: 64.scale),

            showCompatiblePrinterListButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 0.scale),
            showCompatiblePrinterListButton.leadingAnchor.constraint(equalTo: instructionLabel.leadingAnchor),
            showCompatiblePrinterListButton.widthAnchor.constraint(equalToConstant: 200.scale), // Adjust width as necessary
            showCompatiblePrinterListButton.heightAnchor.constraint(equalToConstant: 50.scale),
            
            
        ])
    }
}
