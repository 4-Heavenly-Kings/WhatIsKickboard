//
//  RegisterStackView.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/29/25.
//

import UIKit

import Then
import SnapKit

final class RegisterStackView: UIStackView {
    
    // MARK: - UI Components
    
    private let batteryTextField = UITextField()
    private let locationLabel = UILabel()
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
        setLayout()
    }
    
    // MARK: - Set UIComponents
    
    private func setStyles() {
        axis = .vertical
        spacing = 20
        alignment = .center
        
        batteryTextField.do {
            $0.placeholder = "배터리 잔량(0 ~ 100 사이의 값을 입력해주세요)"
            $0.font = .systemFont(ofSize: 12, weight: .regular)
            $0.layer.cornerRadius = 25
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftView = paddingView
            $0.leftViewMode = .always
        }
        
        locationLabel.do {
            $0.text = "위치"
            $0.textColor = UIColor(hex: "#C4C4C7")
            $0.font = .systemFont(ofSize: 16, weight: .regular)
        }

    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        addArrangedSubviews(batteryTextField, locationLabel)
        
        batteryTextField.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width * 350 / 440)
            $0.height.equalTo(UIScreen.main.bounds.height * 50 / 956)
        }
    }
    
    // MARK: - Methods
    
    func configure(location: String) {
        locationLabel.text = "위치: \(location)"
    }
    
    func getBatteryTextField() -> UITextField {
        return batteryTextField
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
