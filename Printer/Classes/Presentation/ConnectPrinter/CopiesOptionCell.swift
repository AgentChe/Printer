//
//  CopiesOptionCell.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/13/24.
//

import UIKit
class CopiesOptionCell: UICollectionViewCell {
    static let identifier = "CopiesOptionCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.wraps = false
        stepper.autorepeat = true
        stepper.maximumValue = 10
        stepper.minimumValue = 1
        return stepper
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        // Creating the line view
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = Appearance.signatureBlue  // Set the color of the line
        lineView.alpha = 0.5
        // Adding the line view to the contentView
        contentView.addSubview(lineView)
        
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(stepper)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            countLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -8),
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stepper.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Constraints for the line view
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.4)  // Height of the line
        ])
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
    }
    
    private func setupBindings() {
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        countLabel.text = String(format: "%d", Int(sender.value))
    }
    
    func configure(with title: String, count: Int) {
        titleLabel.text = title
        countLabel.text = String(count)
        stepper.value = Double(count)
    }
}
