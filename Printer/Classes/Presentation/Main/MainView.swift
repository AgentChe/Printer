//
//  MainView.swift
//  Printer
//
//  Created by Андрей Чернышев on 24.04.2024.
//

import UIKit
struct PrinterStatus {
    let isConnected: Bool
    let name: String?
}
protocol MainViewDelegate: AnyObject {
    func didSelectQuickAction(_ action: QuickAction)
    func didTapAddPrinter()
    func didTapCompatibleList()
}

final class MainView: UIView {
    weak var delegate: MainViewDelegate?
    var quickActions: [QuickAction] = []
    private let printerImageView: UIImageView = {
        let printerImage = UIImage(named: "Printer.Checked")
        let imageView = UIImageView(image: printerImage)
        imageView.contentMode = .scaleAspectFit
      
        // Настройте изображение и стиль
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        // Настройте стиль заголовка
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        // Настройте стиль подзаголовка
        return label
    }()
    
    private let addPrinterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add printer", for: .normal)
        button.backgroundColor = .systemBlue // Use a color picker to get the exact color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.SFProDisplay.semiBold(size: 18)
        // Use UIFont to set the font and size according to your design
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18) // Adjust the font size accordingly

        // Corner radius for rounded corners
        button.layer.cornerRadius = 24 // Adjust the corner radius to match your design
        
        // Shadow properties
        button.layer.shadowColor = Appearance.addPrinterColor?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0) // These values will need tweaking
        button.layer.shadowRadius = 6 // Adjust the blur radius to match your design
        button.layer.shadowOpacity = 0.4 // Adjust the opacity to match your design
        
        // Set the target-action for the button tap event
        button.addTarget(self, action: #selector(addPrinterButtonTapped), for: .touchUpInside)
        
        return button
    }()

    
    private let compatibleListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Compatible list", for: .normal)
        button.titleLabel?.font = Fonts.SFProDisplay.medium(size: 18)
        // Настройте стиль кнопки и действие
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(compatibleListButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Здесь инициализация UICollectionView, как было показано ранее
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100) // Пример размера ячейки
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(QuickActionCell.self, forCellWithReuseIdentifier: QuickActionCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        return cv
    }()
    // MARK: - Initializers
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func addPrinterButtonTapped() {
        delegate?.didTapAddPrinter()
    }
    
    @objc private func compatibleListButtonTapped() {
        delegate?.didTapCompatibleList()
    }
  
    fileprivate func setupViews() {
        backgroundColor = Appearance.mainViewBackground
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(printerImageView)
        addSubview(addPrinterButton)
        addSubview(compatibleListButton)
        addSubview(collectionView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        printerImageView.translatesAutoresizingMaskIntoConstraints = false
        addPrinterButton.translatesAutoresizingMaskIntoConstraints = false
        compatibleListButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        
        // Title label constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        // Subtitle label constraints
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.scale),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        // Printer image view constraints
        NSLayoutConstraint.activate([
            printerImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20.scale),
            printerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            printerImageView.widthAnchor.constraint(equalToConstant: 150.scale),
            printerImageView.heightAnchor.constraint(equalToConstant: 150.scale)
        ])
        
        // Add printer button constraints
        NSLayoutConstraint.activate([
            addPrinterButton.topAnchor.constraint(equalTo: printerImageView.bottomAnchor, constant: 20.scale),
            addPrinterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addPrinterButton.widthAnchor.constraint(equalToConstant: 361.scale),
            addPrinterButton.heightAnchor.constraint(equalToConstant: 63.scale)
        ])
        
        // Compatible list button constraints
        NSLayoutConstraint.activate([
            compatibleListButton.topAnchor.constraint(equalTo: addPrinterButton.bottomAnchor, constant: 10.scale),
            compatibleListButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            compatibleListButton.widthAnchor.constraint(equalToConstant: 200.scale),
            compatibleListButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])

        // Collection view constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: compatibleListButton.bottomAnchor, constant: 20.scale),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    func updatePrinterStatus(_ status: PrinterStatus?) {
        if let printerStatus = status, printerStatus.isConnected {
            // Обновляем изображение и текст для подключенного принтера
            printerImageView.image = UIImage(named: "connectedPrinterImage") // имя картинки подключенного принтера
            titleLabel.text = "My printer"
            subtitleLabel.text = "Printer \(printerStatus.name ?? "") is connected"
            addPrinterButton.isHidden = true
            compatibleListButton.isHidden = true
        } else {
            // Обновляем изображение и текст для состояния без принтера
            printerImageView.image = UIImage(named: "defaultPrinterImage") // имя картинки по умолчанию
            titleLabel.text = "My printer"
            subtitleLabel.text = "No printer was added"
            addPrinterButton.isHidden = false
            compatibleListButton.isHidden = false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quickActions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuickActionCell.identifier, for: indexPath) as? QuickActionCell else {
            fatalError("Could not dequeue QuickActionCell")
        }
        let action = quickActions[indexPath.item]
        cell.configure(with: action)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = quickActions[indexPath.item]
        delegate?.didSelectQuickAction(action)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width  - 32.scale // Допустим, мы хотим 2 ячейки в ряд
        let height = 78.scale // Высота может быть производной от ширины, зависит от дизайна
        return CGSize(width: width, height: height)
    }
}
