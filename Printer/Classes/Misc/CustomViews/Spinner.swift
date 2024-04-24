//
//  Spinner.swift
//  Printer
//
//  Created by Андрей Чернышев on 23.04.2024.
//

import UIKit

final class Spinner: UIView {
    enum Color {
        case main
    }
    
    private let animationKey = "spinner_rotation_key"
    
    private lazy var isAnimating = false
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame.size = size
        view.image = UIImage(named: "Spinner")
        view.contentMode = .scaleAspectFit
        addSubview(view)
        return view
    }()
    
    private let size: CGSize
    private let color: Color
    
    init(size: CGSize, color: Color = .main) {
        self.size = size
        self.color = color
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isAnimating {
            stopAnimating()
            startAnimating()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        size
    }
}

// MARK: Public
extension Spinner {
    func startAnimating() {
        isHidden = false
        isAnimating = true
        
        guard imageView.layer.animation(forKey: animationKey) == nil else {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = Float.pi * 2
        animation.fromValue = 0
        animation.isCumulative = true
        animation.repeatCount = HUGE
        animation.duration = 2.5
        
        imageView.layer.add(animation, forKey: animationKey)
    }
    
    func stopAnimating() {
        isHidden = true
        isAnimating = false
        
        imageView.layer.removeAnimation(forKey: animationKey)
    }
}

// MARK: Private
private extension Spinner {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}
