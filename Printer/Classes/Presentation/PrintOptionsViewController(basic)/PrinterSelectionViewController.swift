import UIKit

class PrinterSelectionViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Select Printer", comment: "Select Printer")
        
        // Add the Done button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        // Set the background color for the view and table view
        view.backgroundColor = Appearance.white
        tableView.backgroundColor = Appearance.white
        
        // Register your cell class or nib here
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PrinterCell")
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of printers here
        return PrinterManager.shared.retrieveAllPrinters().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrinterCell", for: indexPath)
        // Configure the cell with printer details
        let printer = PrinterManager.shared.retrieveAllPrinters()[indexPath.row]
        cell.textLabel?.text = printer.displayName // Adjust this to fit your data model
        
        // Set the cell background color to white
        cell.backgroundColor = Appearance.white
        cell.contentView.backgroundColor = Appearance.white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle printer selection
        let selectedPrinter = PrinterManager.shared.retrieveAllPrinters()[indexPath.row]
        PrinterManager.shared.connectToPrinter(with: selectedPrinter.url) { printer, error in
            if let printer = printer {
                print("Connected to printer: \(printer.displayName)")
            } else if let error = error {
                print("Failed to connect to printer: \(error.localizedDescription)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
