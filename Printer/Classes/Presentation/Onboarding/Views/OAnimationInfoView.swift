//
//  OAnimationInfoView.swift
//  RingSizer
//
//  Created by Андрей Чернышев on 23.03.2024.
//

import UIKit
import Lottie

final class OAnimationInfoView: OSlideView {
    lazy var animationView = makeAnimationView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var continueButton = makeContinueButton()
    
    private let title: String
    private let subTitle: String
    private let animationName: String
    
    override init(step: OnboardingView.Step) {
        switch step {
        case .connect:
            title = "Onboarding.Connect.Title".localized
            subTitle = "Onboarding.Connect.SubTitle".localized
            animationName = "Onboarding.Connect.Animation"
        case .scan:
            title = "Onboarding.Scan.Title".localized
            subTitle = "Onboarding.Scan.SubTitle".localized
            animationName = "Onboarding.Scan.Animation"
        case .print:
            title = "Onboarding.Print.Title".localized
            subTitle = "Onboarding.Print.SubTitle".localized
            animationName = "Onboarding.Print.Animation"
        }
        
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        animationView.animation = LottieAnimation.named(animationName)
        animationView.play()
    }
}

// MARK: Private
private extension OAnimationInfoView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension OAnimationInfoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 487.scale : 380.scale),
            animationView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 47.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -28.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.widthAnchor.constraint(equalToConstant: 358.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 68.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OAnimationInfoView {
    func makeAnimationView() -> LottieAnimationView {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.SFProDisplay.bold(size: 24.scale))
            .lineHeight(29.scale)
            .textAlignment(.center)
            .letterSpacing(0.36.scale)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.6))
            .font(Fonts.SFPro.regular(size: 18.scale))
            .lineHeight(21.scale)
            .textAlignment(.center)
            .letterSpacing(-0.44.scale)
        
        let view = UILabel()
        view.attributedText = subTitle.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.SFPro.medium(size: 17.scale))
            .letterSpacing(-0.44.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main
        view.layer.cornerRadius = 24.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
