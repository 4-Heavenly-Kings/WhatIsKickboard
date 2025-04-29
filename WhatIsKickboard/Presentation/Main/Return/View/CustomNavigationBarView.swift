//
//  CustomNavigationBarView.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import UIKit

import Then
import SnapKit

final class CustomNavigationBarView: BaseView {
    
    // MARK: - UI Components

    private let backButton = UIButton()
    private let titleLabel = UILabel()
    private let rightButton = UIButton()
        
    // MARK: - Set UIComponents

    override func setStyles() {
        backgroundColor = UIColor(hex: "#FFFFFF")

        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            $0.tintColor = .black
        }
        
        titleLabel.do {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 20, weight: .regular)
            $0.textAlignment = .center
        }
        
        rightButton.do {
            $0.setTitle("저장", for: .normal)
            $0.setTitleColor(UIColor(hex: "#69C6D3"), for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.isHidden = true
        }
    }
    
    // MARK: - Layout Helper

    override func setLayout() {
        addSubviews(backButton, titleLabel, rightButton)
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
    
    // MARK: - Methods

    func configure(title: String, showsRightButton: Bool, rightButtonTitle: String?) {
        titleLabel.text = title
        rightButton.isHidden = !showsRightButton
        
        if let rightButtonTitle = rightButtonTitle {
            rightButton.setTitle(rightButtonTitle, for: .normal)
        }
    }
        
    func getBackButton() -> UIButton {
        return backButton
    }
    
    func getRightButton() -> UIButton {
        return rightButton
    }
}
