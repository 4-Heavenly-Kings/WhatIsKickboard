//
//  CustomSubmitButton.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import UIKit

import Then

final class CustomSubmitButton: UIButton {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    //MARK: - Set UIComponents
    
    private func setStyle() {
        layer.cornerRadius = 25
        tintColor = UIColor(hex: "#FFFFFF")
        titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        backgroundColor = UIColor(hex: "#69C6D3")
    }
    
    // MARK: - Methods
    /// 버튼의 title을 지정하는 configure입니다.
    func configure(buttonTitle: String) {
        setTitle(buttonTitle, for: .normal)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
