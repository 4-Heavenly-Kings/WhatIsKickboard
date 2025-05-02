//
//  UsingKickboardView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

import SnapKit
import Then

//MARK: - UsingKickboardView
final class MyPageUsingKickboardView: BaseView {
    
    //MARK: - Components
    /// 포비 킥보드 Image
    let pobyImageView = UIImageView()
    /// 배터리 잔량 Image
    let batteryImageView = UIImageView()
    /// 배터리 잔량 Label
    let batteryLabel = UILabel()
    /// 사용자 이름 Label
    let userNameLabel = UILabel()
    /// 킥보드  사용중 Label
    let usingTimeLabel = UILabel()
    
    // MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
        pobyImageView.do {
            $0.image = UIImage(named: "PobyRiding")
            $0.contentMode = .scaleAspectFit
        }
        
        batteryImageView.do {
            $0.image = UIImage(systemName: "battery.50percent")
            $0.tintColor = .black
            $0.contentMode = .scaleAspectFit
            $0.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
        }
        
        batteryLabel.do {
            $0.text = "배터리 50%"
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.textColor = .black
        }
        
        userNameLabel.do {
            $0.textAlignment = .center
        }
        
        usingTimeLabel.do {
            $0.textAlignment = .center
            $0.textColor = .black
        }
        
    }
    
    // MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
        self.addSubviews(pobyImageView, batteryImageView, batteryLabel, userNameLabel, usingTimeLabel)
        
        pobyImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(25)
            $0.width.equalTo(75)
            $0.height.equalTo(pobyImageView.snp.width).multipliedBy(1.5)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        usingTimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalTo(pobyImageView.snp.bottom)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.trailing.equalTo(usingTimeLabel.snp.leading).offset(-5)
            $0.bottom.equalTo(usingTimeLabel)
        }
        
        batteryLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalTo(usingTimeLabel.snp.top).offset(-10)
        }
        
        batteryImageView.snp.makeConstraints {
            $0.trailing.equalTo(batteryLabel.snp.leading)
            $0.bottom.equalTo(batteryLabel)
            $0.size.equalTo(20)
        }
    }
}
