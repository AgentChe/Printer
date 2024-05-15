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
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dropbox Files"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        fetchDropboxFiles()
    }
    
    private func fetchDropboxFiles() {
        print("Fetching Dropbox files...")
        DropboxClientsManager.authorizedClient?.files.listFolder(path: "").response { [weak self] response, error in
            if let result = response {
                print("Files fetched: \(result.entries.count)")
                self?.files = result.entries
                self?.tableView.reloadData()
            } else if let error = error {
                print("Error fetching files: \(error)")
            } else {
                print("No error, no result. Something went wrong.")
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = files[indexPath.row]
        delegate?.didSelectDropboxFile(selectedFile)
        dismiss(animated: true, completion: nil)
    }
}
