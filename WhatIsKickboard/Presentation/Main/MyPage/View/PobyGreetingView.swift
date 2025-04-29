//
//  PobyGreetingView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

import SnapKit
import Then

final class PobyGreetingView: BaseView {
    
    let pobyGreetingImage = UIImageView()
    let userNameLabel = UILabel()
    let greetingLabel = UILabel()
    let greetingStackView = UIStackView()
    let subGreetingLabel = UILabel()
    
    override func setStyles() {
        super.setStyles()
        
        pobyGreetingImage.do {
            $0.image = UIImage(named: "PobyHi")
            $0.contentMode = .scaleAspectFit
        }
        
        userNameLabel.do {
            $0.text = "회원"
            $0.textColor = UIColor(hex: "#69C6D3")
            $0.font = UIFont(name: "Jalnan2", size: 28)
            $0.textAlignment = .center
        }
        
        greetingLabel.do {
            $0.text = "님, 안녕하세요!"
            $0.font = UIFont(name: "Jalnan2", size: 28)
            $0.textAlignment = .center
        }
        
        greetingStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
        }
        
        subGreetingLabel.do {
            $0.text = "오늘도 포비와 함께 달려보아요!"
            $0.font = UIFont(name: "Jalnan2", size: 18)
            $0.textAlignment = .center
        }
        
        self.addSubviews(pobyGreetingImage, greetingStackView, subGreetingLabel)
        greetingStackView.addArrangedSubviews(userNameLabel, greetingLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        pobyGreetingImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(120)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(pobyGreetingImage.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        greetingStackView.snp.makeConstraints {
            $0.top.equalTo(pobyGreetingImage.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        subGreetingLabel.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
