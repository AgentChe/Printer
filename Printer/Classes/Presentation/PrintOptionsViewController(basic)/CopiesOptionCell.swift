// CopiesOptionCell.swift
// Printer

import UIKit

class CopiesOptionCell: UICollectionViewCell {
    static let identifier = "CopiesOptionCell"
    weak var delegate: CopiesOptionCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Fonts.SFProDisplay.medium(size: 17.scale) // Custom font with .scale
        label.textColor = Appearance.black // Set text color to Appearance.black
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Fonts.SFProDisplay.regular(size: 16.scale) // Custom font with .scale
        label.textColor = Appearance.black // Set text color to Appearance.black
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
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.scale),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -4.scale),
            
            countLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -8.scale),
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -4.scale),
            
            stepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0.scale),
            stepper.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -4.scale),
            
            // Constraints for the line view
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.scale),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0.scale),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.4.scale)  // Height of the line
        ])
        
        contentView.backgroundColor = Appearance.white // Set background color to Appearance.white
        contentView.layer.cornerRadius = 10.scale
    }
    
    private func setupBindings() {
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        let newCount = Int(sender.value)
        countLabel.text = String(format: "%d", newCount)
        delegate?.copiesOptionCell(cell: self, didChangeCopiesTo: newCount)
    }
    
    func configure(with title: String, count: Int) {
        titleLabel.text = title
        countLabel.text = String(count)
        stepper.value = Double(count)
    }
}
