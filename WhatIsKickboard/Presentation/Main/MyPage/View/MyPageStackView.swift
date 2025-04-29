//
//  MyPageStackView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

import SnapKit
import Then

//MARK: - MyPageStackView
final class MyPageStackView: UIStackView {
    
    // MARK: - Components
    /// 이름 수정 Button
    let modifyNameLabel = MyPageStackButton(title: "이름 수정")
    /// 비밀번호 수정 Button
    let modifyPasswordLabel = MyPageStackButton(title: "비밀번호 수정")
    /// 이용 내역 Button
    let useDetailLabel = MyPageStackButton(title: "이용 내역")
    /// 로그아웃 Button
    let logoutLabel = MyPageStackButton(title: "로그아웃", titleColor: .systemRed)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Styles
    private func setStyles() {
        self.axis = .vertical
        self.alignment = .fill
        self.spacing = 1
        self.distribution = .fillEqually
        self.backgroundColor = .systemGray5
    }
    
    // MARK: - Layouts
    private func setLayout() {
        self.addArrangedSubviews(modifyNameLabel, modifyPasswordLabel, useDetailLabel, logoutLabel)
    }
}
