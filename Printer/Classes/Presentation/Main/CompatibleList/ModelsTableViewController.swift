import UIKit
import UIKit

class ModelsTableViewController: UITableViewController {
    
    var models: [String] = []
    var brand: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = brand ?? "Models"
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Appearance.white
            appearance.titleTextAttributes = [
                .foregroundColor: Appearance.black,
                .font: Fonts.SFProDisplay.semiBold(size: 19) // Set title font
            ]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        }
        tableView.backgroundColor = Appearance.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "modelCell")
        tableView.allowsSelection = false // Disable selection for the entire table view
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "modelCell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.textColor = Appearance.black
        cell.textLabel?.font = Fonts.SFProDisplay.medium(size: 16)
        cell.backgroundColor = Appearance.white
        
        // Disable user interaction for the cell
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        if indexPath.item == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            // Add a custom separator view
            let separatorHeight = 1.0 / UIScreen.main.scale // To make the line as thin as the default separator
            let separator = UIView(frame: CGRect(x: 0, y: (cell.frame.size.height - separatorHeight).scale, width: cell.frame.size.width.scale, height: separatorHeight.scale))
            separator.backgroundColor = .lightGray // Set the color of your separator
            separator.tag = 12345 // Tag the separator to identify and remove it if needed
            cell.addSubview(separator)
            separator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                separator.leftAnchor.constraint(equalTo: cell.leftAnchor, constant:  15.scale),
                separator.rightAnchor.constraint(equalTo: cell.rightAnchor),
                separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: separatorHeight)
            ])
        }
        return cell
    }
}
