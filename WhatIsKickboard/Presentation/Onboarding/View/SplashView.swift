//
//  SplashView.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/29/25.
//

import UIKit

// MARK: - SplashView
final class SplashView: BaseView {
    
    // MARK: - Components
    private let titleView = UIImageView()
    private let titleImageView = UIImageView()
    
    // MARK: 오토 레이아웃
    override func setLayout() {
        addSubviews(titleView, titleImageView)
        
        titleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(196)
            $0.height.equalTo(86)
        }
        
        titleImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(35)
            $0.width.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
    // MARK: - Component 스타일 및 View 스타일 설정
    override func setStyles() {
        backgroundColor = UIColor(hex: "F5F6F8", alpha: 1.0)
        
        titleView.do {
            $0.image = UIImage(named: "SplashTitle")
            $0.contentMode = .scaleAspectFit
        }
        
        titleImageView.do {
            $0.image = UIImage(named: "SplashPoby")
            $0.contentMode = .scaleAspectFit
        }
    }
}
