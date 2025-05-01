//
//  ModifyStackView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import UIKit

import Then
import SnapKit

final class ModifyStackView: UIStackView {
    
    // MARK: - UI Components
    private(set) var modifyTextFiled = UITextField()
    private(set) var modifyCheckTextFiled = UITextField()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UIComponents
    private func setStyles() {
        self.axis = .vertical
        self.spacing = 8
        self.alignment = .center
        
        modifyTextFiled.do {
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.layer.cornerRadius = 25
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftView = paddingView
            $0.leftViewMode = .always
        }
        
        modifyCheckTextFiled.do {
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.layer.cornerRadius = 25
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftView = paddingView
            $0.leftViewMode = .always
        }

    }
    
    // MARK: - Methods
    func configure(_ modidyType: ModifyType) {
        if modidyType == .name {
            modifyTextFiled.placeholder = modidyType.placeholder
            modifyCheckTextFiled.isHidden = true
        } else {
            modifyTextFiled.placeholder = modidyType.placeholder + " 입력"
            modifyCheckTextFiled.placeholder = modidyType.placeholder + " 확인"
        }
    }
    
    // MARK: - Layouts
    private func setLayout() {
        addArrangedSubviews(modifyTextFiled, modifyCheckTextFiled)
        
        modifyTextFiled.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width * 350 / 440)
            $0.height.equalTo(UIScreen.main.bounds.height * 50 / 956)
        }
        
        modifyCheckTextFiled.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width * 350 / 440)
            $0.height.equalTo(UIScreen.main.bounds.height * 50 / 956)
        }
    }
}
