import UIKit
import SwiftyDropbox

protocol DropboxFilesViewControllerDelegate: AnyObject {
    func didSelectDropboxFile(_ file: Files.Metadata)
}

final class DropboxFilesViewController: UIViewController {
    private var files = [Files.Metadata]()
    weak var delegate: DropboxFilesViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropboxFileCell")
        tableView.backgroundColor = Appearance.mainViewBackground // Set table view background color
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("DropboxFilesViewController.Title", comment: "")
        view.backgroundColor = Appearance.mainViewBackground // Set view background color
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        fetchDropboxFiles()

        // Set title text color
        if let navigationBar = navigationController?.navigationBar {
            let titleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: Appearance.black]
            navigationBar.titleTextAttributes = titleAttributes
        }
    }
    
    private func fetchDropboxFiles() {
        print(NSLocalizedString("DropboxFilesViewController.Fetching", comment: ""))
        DropboxClientsManager.authorizedClient?.files.listFolder(path: "").response { [weak self] response, error in
            if let result = response {
                print(String(format: NSLocalizedString("DropboxFilesViewController.FilesFetched", comment: ""), result.entries.count))
                self?.files = result.entries
                self?.tableView.reloadData()
            } else if let error = error {
                print(String(format: NSLocalizedString("DropboxFilesViewController.ErrorFetching", comment: ""), error.localizedDescription))
            } else {
                print(NSLocalizedString("DropboxFilesViewController.NoErrorNoResult", comment: ""))
            }
        }
    }
}

extension DropboxFilesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropboxFileCell", for: indexPath)
        cell.textLabel?.text = files[indexPath.row].name
        cell.textLabel?.textColor = Appearance.black // Set text color to Appearance.black
        cell.backgroundColor = Appearance.white // Set cell background color to Appearance.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = files[indexPath.row]
        delegate?.didSelectDropboxFile(selectedFile)
        dismiss(animated: true, completion: nil)
    }
}
