//
//  ModifyView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import UIKit

import SnapKit
import Then

// MARK: - ModifyView
final class ModifyView: BaseView {
    
    // MARK: - UI Components
    private let statusBarBackgroundView = UIView()
    private(set) var navigationBarView = CustomNavigationBarView()
    let modifyStackView = ModifyStackView()

    // MARK: - Styles
    override func setStyles() {
        backgroundColor = UIColor(hex: "#F5F6F8")
        
        statusBarBackgroundView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
        }

    }
    
    // MARK: - Layouts
    override func setLayout() {
        self.addSubviews(statusBarBackgroundView, navigationBarView, modifyStackView)
        
        statusBarBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        modifyStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
        }
    }
}
