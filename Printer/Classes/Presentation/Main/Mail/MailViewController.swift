import UIKit

class MailViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private let statusBarBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(StepCell.self, forCellWithReuseIdentifier: StepCell.identifier)
        cv.backgroundColor = Appearance.mainViewBackground // Set background color to Appearance.mainViewBackground
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
    
    // Invisible view to increase tap area of the close button
    private let closeButtonHitArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Appearance.mainViewBackground // Set background color to Appearance.mainViewBackground
        title = NSLocalizedString("MailViewController.Title", comment: "")
        
        setupCollectionView()
        setupCloseButton()
        setupStatusBarBackgroundView()
    }
    
    private func setupStatusBarBackgroundView() {
        view.addSubview(statusBarBackgroundView)
        
        // Constraints for the status bar background view
        NSLayoutConstraint.activate([
            statusBarBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarBackgroundView.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.height)
        ])
    }
    
    private func setupCollectionView() {
        view.insertSubview(collectionView, belowSubview: closeButton)
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
        view.addSubview(closeButtonHitArea)
        view.addSubview(closeButton)
        
        // Constraints for the close button hit area
        NSLayoutConstraint.activate([
            closeButtonHitArea.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            closeButtonHitArea.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor),
            closeButtonHitArea.widthAnchor.constraint(equalToConstant: 72), // Four times the width of the button
            closeButtonHitArea.heightAnchor.constraint(equalToConstant: 80) // Four times the height of the button
        ])
        
        // Constraints for the close button
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        // Add tap gesture recognizer to the hit area
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        closeButtonHitArea.addGestureRecognizer(tapGesture)
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
        switch indexPath.item {
        case 0:
            return CGSize(width: collectionView.frame.width - 20, height: 298.scale)
        case 1:
            return CGSize(width: collectionView.frame.width - 20, height: 320.scale)
        case 2:
            return CGSize(width: collectionView.frame.width - 20, height: 320.scale)
        case 3:
            return CGSize(width: collectionView.frame.width - 20, height: 342.scale)
        default:
            return CGSize(width: collectionView.frame.width - 20, height: 320.scale)
        }
    }
    
    private func getStepData(for index: Int) -> StepData {
        switch index {
        case 0:
            return StepData(
                title: NSLocalizedString("MailViewController.Step1.Title", comment: ""),
                subtitle: NSLocalizedString("MailViewController.Step1.Subtitle", comment: ""),
                description: NSLocalizedString("MailViewController.Step1.Description", comment: ""),
                image: UIImage(named: "Email.FindMail")
            )
        case 1:
            return StepData(
                title: NSLocalizedString("MailViewController.Step2.Title", comment: ""),
                subtitle: NSLocalizedString("MailViewController.Step2.Subtitle", comment: ""),
                description: NSLocalizedString("MailViewController.Step2.Description", comment: ""),
                image: UIImage(named: "Email.OpenAttachment")
            )
        case 2:
            return StepData(
                title: NSLocalizedString("MailViewController.Step3.Title", comment: ""),
                subtitle: NSLocalizedString("MailViewController.Step3.Subtitle", comment: ""),
                description: NSLocalizedString("MailViewController.Step3.Description", comment: ""),
                image: UIImage(named: "Email.ShareAttachment")
            )
        case 3:
            return StepData(
                title: NSLocalizedString("MailViewController.Step4.Title", comment: ""),
                subtitle: NSLocalizedString("MailViewController.Step4.Subtitle", comment: ""),
                description: NSLocalizedString("MailViewController.Step4.Description", comment: ""),
                image: UIImage(named: "Email.PrintAttachment")
            )
        default:
            return StepData(title: "", subtitle: "", description: "", image: nil)
        }
    }
}
