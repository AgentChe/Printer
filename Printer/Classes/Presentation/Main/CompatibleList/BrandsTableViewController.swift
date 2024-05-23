import UIKit

class BrandsTableViewController: UITableViewController {
    
    var printerData: PrinterData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Printer Brands"
        
        // Set navigation bar appearance
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Appearance.white
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: Fonts.SFProDisplay.bold(size: 19) // Set title font
            ]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        }
        
        // Set table view appearance
        tableView.backgroundColor = Appearance.white
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Load printer data
        printerData = PrinterData(fileName: "PrinterModels")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return printerData?.printers.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let brand = printerData?.printers[indexPath.row].brand
        cell.textLabel?.text = brand
        cell.textLabel?.textColor = Appearance.black
        cell.textLabel?.font = Fonts.SFProDisplay.medium(size: 16)
        cell.backgroundColor = Appearance.white
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelsVC = ModelsTableViewController()
        modelsVC.models = printerData?.printers[indexPath.row].models ?? []
        modelsVC.brand = printerData?.printers[indexPath.row].brand
        
        // Set empty back button title for the next view controller
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        navigationController?.pushViewController(modelsVC, animated: true)
    }
}

class CustomTableViewCell: UITableViewCell {

    private let chevronImageView: UIImageView = {
        let chevron = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: chevron)
        imageView.tintColor = Appearance.signatureBlue
        imageView.backgroundColor = .clear // Ensure background is transparent
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAccessoryView()
        setupBackgroundColor()
        setupSelectedBackgroundView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAccessoryView()
        setupBackgroundColor()
        setupSelectedBackgroundView()
    }

    private func setupAccessoryView() {
        accessoryView = chevronImageView
    }

    private func setupBackgroundColor() {
        backgroundColor = Appearance.white
        contentView.backgroundColor = Appearance.white
    }

    private func setupSelectedBackgroundView() {
        let clearView = UIView()
        clearView.backgroundColor = Appearance.white
        selectedBackgroundView = clearView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Ensure the background color does not change when selected
        if selected {
            backgroundColor = Appearance.white
            contentView.backgroundColor = Appearance.white
        } else {
            backgroundColor = Appearance.white
            contentView.backgroundColor = Appearance.white
        }

        // Reset chevron image view background color
        chevronImageView.backgroundColor = .clear
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        // Ensure the background color does not change when highlighted
        if highlighted {
            backgroundColor = Appearance.white
            contentView.backgroundColor = Appearance.white
        } else {
            backgroundColor = Appearance.white
            contentView.backgroundColor = Appearance.white
        }

        // Reset chevron image view background color
        chevronImageView.backgroundColor = .clear
    }
}
