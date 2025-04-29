//
//  MyPageStackView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

import SnapKit
import Then

final class MyPageStackView: UIStackView {
    
    let backgroundView = UIView()
    let modifyNameLabel = MyPageStackButton(title: "이름 수정")
    let modifyPasswordLabel = MyPageStackButton(title: "비밀번호 수정")
    let useDetailLabel = MyPageStackButton(title: "이용 내역")
    let logoutLabel = MyPageStackButton(title: "로그아웃", titleColor: .systemRed)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// View 의 Style 을 set 합니다.
    func setStyles() {
        self.axis = .vertical
        self.alignment = .fill
        self.spacing = 1
        self.distribution = .fillEqually
        self.backgroundColor = .systemGray5
        
        self.addArrangedSubviews(modifyNameLabel, modifyPasswordLabel, useDetailLabel, logoutLabel)
    }
    
    /// View 의 Layout 을 set 합니다.
    func setLayout() {}
}
