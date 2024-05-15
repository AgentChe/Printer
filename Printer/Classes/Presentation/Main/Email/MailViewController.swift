import UIKit

class MailViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(StepCell.self, forCellWithReuseIdentifier: StepCell.identifier)
        return cv
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.alpha = 0.6
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Email"
        
        setupCollectionView()
        setupCloseButton()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension MailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StepCell.identifier, for: indexPath) as? StepCell else {
            return UICollectionViewCell()
        }
        
        let stepData = getStepData(for: indexPath.row)
        cell.configure(with: stepData, index: indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 298.scale)
    }
    
    private func getStepData(for index: Int) -> StepData {
        switch index {
        case 0:
            return StepData(title: "Step 1", subtitle: "Find mail", description: "Find needed email in any email client", image: UIImage(named: "Email.FindMail"))
        case 1:
            return StepData(title: "Step 2", subtitle: "Open attachment", description: "Find attachment at the bottom of your email and tap top open preview", image: UIImage(named: "Email.OpenAttachment"))
        case 2:
            return StepData(title: "Step 3", subtitle: "Share attachment", description: "Tap Share button in attachment preview screen. Scroll share action sheet and find Copy to Printer App", image: UIImage(named: "Email.ShareAttachment"))
        case 3:
            return StepData(title: "Step 4", subtitle: "Print attachment", description: "In our app tap Print button on the document preview page and follow the further instructions on the screen to set up printing", image: UIImage(named: "Email.PrintAttachment"))
        default:
            return StepData(title: "", subtitle: "", description: "", image: nil)
        }
    }
}
