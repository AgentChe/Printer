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
        return cell
    }
}
