//
//  PobyGreetingView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

import SnapKit
import Then

//MARK: - PobyGreetingView
final class PobyGreetingView: BaseView {
    
    //MARK: - Components
    /// 포비 인사 Image
    let pobyGreetingImage = UIImageView()
    /// 사용자 이름 + 인사말 Label
    let userNameGreetingLabel = UILabel()
    /// 서브 인사말 Label
    let subGreetingLabel = UILabel()
    
    // MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
        pobyGreetingImage.do {
            $0.image = UIImage(named: "PobyHi")
            $0.contentMode = .scaleAspectFit
        }
        
        userNameGreetingLabel.do {
            $0.textAlignment = .center
        }
        
        subGreetingLabel.do {
            $0.text = "오늘도 포비와 함께 달려보아요!"
            $0.font = UIFont(name: "Jalnan2", size: 18)
            $0.textAlignment = .center
        }
    }
    
    // MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
        self.addSubviews(pobyGreetingImage, userNameGreetingLabel, subGreetingLabel)
        
        pobyGreetingImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(120)
        }
        
        userNameGreetingLabel.snp.makeConstraints {
            $0.top.equalTo(pobyGreetingImage.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        userNameGreetingLabel.snp.makeConstraints {
            $0.top.equalTo(pobyGreetingImage.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        subGreetingLabel.snp.makeConstraints {
            $0.top.equalTo(userNameGreetingLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
