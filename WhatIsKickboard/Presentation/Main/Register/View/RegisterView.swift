//
//  RegisterView.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/29/25.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift

final class RegisterView: BaseView {
    
    // MARK: - UI Components
    
    private let statusBarBackgroundView = UIView()
    private(set) var navigationBarView = CustomNavigationBarView()
    private(set) var registerStackView = RegisterStackView()
    
    
    // MARK: - Set UIComponents
    
    override func setStyles() {
        backgroundColor = UIColor(hex: "#F5F6F8")
        
        statusBarBackgroundView.do {
            $0.backgroundColor = UIColor(hex: "#FFFFFF")
        }
        
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        addSubviews(statusBarBackgroundView, navigationBarView, registerStackView)
        
        statusBarBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(statusBarBackgroundView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        registerStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    func getStatusBarBackgroundView() -> UIView {
        return statusBarBackgroundView
    }
    
    private func getSafeAreaTop() -> CGFloat {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets.top ?? 20 // fallback
    }
    
    func updateStatusBarHeight(_ height: CGFloat) {
        statusBarBackgroundView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
