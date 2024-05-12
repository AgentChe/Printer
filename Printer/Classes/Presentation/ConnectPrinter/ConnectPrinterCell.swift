//
//  ConnectPrinterCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/10/24.
//

import UIKit

class ConnectPrinterCell: UICollectionViewCell {
    static let connectPrinterCellKey = "connectPrinterCellKey"
    weak var delegate: ConnectPrinterCellDelegate?
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
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
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
        
        // Create and configure a UIButton.Configuration instance
        var config = UIButton.Configuration.filled()
        config.title = "New printer"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = Appearance.signatureBlue
        config.cornerStyle = .medium // This can be adjusted to match your design requirements
        
        // Custom font setup
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = Fonts.SFProDisplay.medium(size: 16)
            return outgoing
        }
        
        // Apply the configuration to the button
        button.configuration = config
        button.layer.cornerRadius = 23
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectPrinter), for: .touchUpInside) // Assuming selectPrinter is the selector method
        
        // Adjust title position using a padding configuration
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: -1.7, leading: 0, bottom: 0, trailing: 0)
        
        return button
    }()
    @objc func closeButtonTapped() {
        delegate?.dismissViewController()
    }
    @objc func selectPrinter() {
        let printerPicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
        
        printerPicker.present(animated: true) { [weak self] (printerPickerController, userDidSelect, error) in
            if userDidSelect {
                if let printer = printerPickerController.selectedPrinter {
                    print("Printer name: \(printer.displayName)")
                    print("Printer URL: \(printer.url)")
                    
                    let isFirstTimeSaved =  PrinterManager.shared.isFirstTimePrinterSaved(printer.url)
                    PrinterManager.shared.savePrinter(url: printer.url, displayName: printer.displayName)
                    
                    PrinterManager.shared.connectToPrinter(with: printer.url) { printer, error in
                        if let printer = printer {
                            print("Ready to print with \(printer.displayName)")
                            self?.delegate?.reloadCollectionView()
                            if isFirstTimeSaved {
                                print("First time connection to \(printer.displayName)")
                            }
                            
                            if let viewController4Print = self?.parentViewController {
                                let printTestFileVC = PrintTestFileViewController()
                                printTestFileVC.modalPresentationStyle = .fullScreen
                                viewController4Print.present(printTestFileVC, animated: true, completion: nil)
                                //PrinterManager.shared.printDocument(printer: printer, from: viewController4Print)
                            }
                        }
                        if let error = error {
                            if let viewController4Alert = self?.parentViewController {
                                PrinterManager.shared.showAlertForErrorWithPrinter(printer?.displayName ?? "Unknown", viewController: viewController4Alert)
                            }
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    
                }
            }
        }
    }
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
        let attributedTitle = NSAttributedString(string: "Printer compatible list", attributes: [
            .font: Fonts.SFProDisplay.medium(size: 16),
            .foregroundColor: UIColor.systemBlue,
            .kern: 0.2 // Set kerning
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .left
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Appearance.mainViewBackground
        wifi2ndManager.delegate = self
        
        bluetoothManager.delegate = self
        
        setupConnectionCheckTimer()
        
        addSubview(headerLabel)
        addSubview(detailLabel)
        addSubview(closeButton)
        addSubview(bluetoothToggleView)
        addSubview(wifiToggleView)
        addSubview(addPrinterButton)
        addSubview(availablePrintersLabel)
        addSubview(instructionLabel)
        addSubview(showCompatiblePrinterListButton)
        
        // Use AutoLayout to position the views
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        bluetoothToggleView.translatesAutoresizingMaskIntoConstraints = false
        wifiToggleView.translatesAutoresizingMaskIntoConstraints = false
        availablePrintersLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        showCompatiblePrinterListButton.translatesAutoresizingMaskIntoConstraints = false
        
        let view = self
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ConnectPrinterCell:StatusChangeDelegate {
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
}
