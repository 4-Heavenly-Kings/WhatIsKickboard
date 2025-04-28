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
    let greetingLabel = UILabel()
    let subGreetingLabel = UILabel()
    
    override func setStyles() {
        super.setStyles()
        
        pobyGreetingImage.do {
            $0.image = UIImage(named: "PobyHi")
            $0.contentMode = .scaleAspectFit
        }
        
        greetingLabel.do {
            $0.text = "회원님, 안녕하세요!"
            $0.font = UIFont(name: "Jalnan2", size: 20)
            $0.textAlignment = .center
        }
        
        subGreetingLabel.do {
            $0.text = "오늘도 포비와 함께 달려보아요!"
            $0.font = UIFont(name: "Jalnan2", size: 15)
            $0.textAlignment = .center
        }
        
        self.addSubviews(pobyGreetingImage, greetingLabel, subGreetingLabel)
    }
    
    override func setLayout() {
        super.setLayout()
        
        pobyGreetingImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        greetingLabel.snp.makeConstraints {
            $0.top.equalTo(pobyGreetingImage.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        subGreetingLabel.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
