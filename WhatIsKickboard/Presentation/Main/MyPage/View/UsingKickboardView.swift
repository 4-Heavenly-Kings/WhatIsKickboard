//
//  UsingKickboardView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

import SnapKit
import Then

final class UsingKickboardView: BaseView {
    
    let pobyImageView = UIImageView()
    let batteryImageView = UIImageView()
    let batteryLabel = UILabel()
    let userNameLabel = UILabel()
    let titleLabel = UILabel()
    let usingTimeLabel = UILabel()
    let usingLabel = UILabel()
    
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
            $0.text = "홍길동"
            $0.font = .systemFont(ofSize: 30, weight: .bold)
            $0.textColor = UIColor(hex: "#69C6D3")
        }
        
        titleLabel.do {
            $0.text = "님!"
            $0.font = .systemFont(ofSize: 30, weight: .regular)
            $0.textColor = .black
        }
        
        usingTimeLabel.do {
            $0.text = "15분"
            $0.font = .systemFont(ofSize: 30, weight: .bold)
            $0.textColor = .black
        }
        
        usingLabel.do {
            $0.text = "이용 중"
            $0.font = .systemFont(ofSize: 30, weight: .regular)
            $0.textColor = .black
        }
        
        self.addSubviews(pobyImageView, batteryImageView, batteryLabel, userNameLabel, titleLabel, usingTimeLabel, usingLabel)
        
    }
    
    override func setLayout() {
        super.setLayout()
        
        pobyImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().offset(25)
            $0.width.equalTo(75)
            $0.height.equalTo(pobyImageView.snp.width).multipliedBy(1.5)
            $0.bottom.equalTo(-16)
        }
        
        usingLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalTo(pobyImageView)
        }
        
        usingTimeLabel.snp.makeConstraints {
            $0.trailing.equalTo(usingLabel.snp.leading).offset(-3)
            $0.bottom.equalTo(usingLabel)
        }
        
        titleLabel.snp.makeConstraints {
            $0.trailing.equalTo(usingTimeLabel.snp.leading).offset(-10)
            $0.bottom.equalTo(usingTimeLabel)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.trailing.equalTo(titleLabel.snp.leading)
            $0.bottom.equalTo(titleLabel)
        }
        
        batteryLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalTo(usingLabel.snp.top).offset(-10)
        }
        
        batteryImageView.snp.makeConstraints {
            $0.trailing.equalTo(batteryLabel.snp.leading)
            $0.bottom.equalTo(batteryLabel)
            $0.size.equalTo(20)
        }
        
    }
}
