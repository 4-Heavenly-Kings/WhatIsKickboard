//
//  CustomAlertView.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import UIKit

import Then
import SnapKit

final class CustomAlertView: BaseView {
    
    // MARK: - UI Components

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let horizontalSeparator = UIView()
    private let verticalSeparator = UIView()
    private let submitButton = UIButton()
    private let cancelButton = UIButton()
    
    // MARK: - Properties
    
    private let alertType: CustomAlertViewType
    
    // MARK: - Initializer
    
    init(frame: CGRect, alertType: CustomAlertViewType) {
        self.alertType = alertType
        super.init(frame: frame)
    }
    
    // MARK: - Set UIComponents
    
    override func setStyles() {
        backgroundColor = UIColor(hex: "#000000").withAlphaComponent(0.5)
        
        containerView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            $0.layer.cornerRadius = 20
        }
        
        switch alertType {
        case .returnRequest, .logout, .deleteID:
            imageView.do {
                $0.image = UIImage(named: "PobyHi")
            }
            
            titleLabel.do {
                $0.font = .systemFont(ofSize: 20, weight: .regular)
                $0.textColor = UIColor(hex: "#000000")
            }
            
            subtitleLabel.do {
                $0.textColor = UIColor(hex: "#000000")
                $0.numberOfLines = 2
                $0.textAlignment = .center
                $0.font = UIFont.jalnan2(20)
            }
            
            buttonStackView.do {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
            }
            
            horizontalSeparator.do {
                $0.backgroundColor = UIColor(hex: "#000000")
            }
            
            verticalSeparator.do {
                $0.backgroundColor = UIColor(hex: "#000000")
            }
            
            submitButton.do {
                $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            }
            
            cancelButton.do {
                $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
                $0.tintColor = UIColor(hex: "#69C6D3")
            }
        case .confirmReturn:
            imageView.do {
                $0.image = UIImage(named: "PobyRiding")
            }
            
            titleLabel.do {
                $0.font = .systemFont(ofSize: 18, weight: .regular)
                $0.textColor = UIColor(hex: "#000000")
            }
            
            horizontalSeparator.do {
                $0.backgroundColor = UIColor(hex: "#000000")
            }
            
            submitButton.do {
                $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            }
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        
        switch alertType {
        case .returnRequest, .logout, .deleteID:
            addSubviews(containerView)
            containerView.addSubviews(imageView, titleLabel, subtitleLabel, buttonStackView, verticalSeparator, horizontalSeparator)
            buttonStackView.addArrangedSubviews(submitButton, cancelButton)
            
            containerView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.width * 400 / 440)
                $0.height.equalTo(UIScreen.main.bounds.height * 400 / 956)
            }
            
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(45)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.width * 84 / 440)
                $0.height.equalTo(UIScreen.main.bounds.height * 100 / 956)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(17)
                $0.centerX.equalToSuperview()
            }
            
            subtitleLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(38)
                $0.centerX.equalToSuperview()
            }
            
            horizontalSeparator.snp.makeConstraints {
                $0.top.equalTo(buttonStackView.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(1)
            }
            
            buttonStackView.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(UIScreen.main.bounds.height * 85 / 956)
            }
            
            verticalSeparator.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(buttonStackView.snp.top)
                $0.bottom.equalTo(buttonStackView.snp.bottom)
                $0.width.equalTo(1)
            }
        case .confirmReturn:
            addSubviews(containerView)
            containerView.addSubviews(imageView, titleLabel, horizontalSeparator, buttonStackView)
            buttonStackView.addArrangedSubviews(submitButton)
            
            containerView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.width * 400 / 440)
                $0.height.equalTo(UIScreen.main.bounds.height * 400 / 956)
            }
            
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(45)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(UIScreen.main.bounds.width * 73 / 440)
                $0.height.equalTo(UIScreen.main.bounds.height * 109 / 956)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(56)
                $0.centerX.equalToSuperview()
            }
            
            horizontalSeparator.snp.makeConstraints {
                $0.top.equalTo(buttonStackView.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(1)
            }
            
            buttonStackView.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(UIScreen.main.bounds.height * 85 / 956)
            }
            
        }
    }
    
    // MARK: - Methods
    /// 사용자의 이름, 킥보드 사용시간, 킥보드 탑승 횟수, 가격
    /// 반납 Alert의 경우: 사용자의 이름과 킥보드 사용시간 가격을 configure에 작성
    /// 로그아웃+회원탈퇴의 경우: 사용자의 이름과 킥보드 탑승 횟수
    /// 만약 사용자가 킥보드를 아예 사용한 적이 없을 경우 'name님은 포비와 함께 했어요' 라는 예외 처리.
    func configure(name: String, minutes: Int?, count: Int?, price: String?) {
        titleLabel.attributedText = alertType.makeTitle(name: name, minutes: minutes, count: count)
        subtitleLabel.text = alertType.makeSubtitle(price: price)
        
        submitButton.setTitle(alertType.submitTitle, for: .normal)
        submitButton.setTitleColor(alertType.submitTitleColor, for: .normal)
        
        cancelButton.setTitle(alertType.cancelTitle, for: .normal)
        cancelButton.setTitleColor(alertType.cancelTitleColor, for: .normal)
    }
    
    func getSubmitButton() -> UIButton {
        return submitButton
    }
    
    func getCancelButton() -> UIButton {
        return cancelButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
