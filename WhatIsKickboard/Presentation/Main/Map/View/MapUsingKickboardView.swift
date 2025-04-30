//
//  MapUsingKickboardView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/29/25.
//

import UIKit

import SnapKit
import Then

//MARK: - UsingKickboardView
final class MapUsingKickboardView: BaseView {
    
    //MARK: - Components
    /// 포비 킥보드 Image
    let pobyImageView = UIImageView()
    /// 배터리 잔량 Image
    let batteryImageView = UIImageView()
    /// 배터리 잔량 Label
    let batteryLabel = UILabel()
    /// 킥보드  사용중 Label
    let usingTimeLabel = UILabel()
    /// 요금 StackView
    let priceStackView = PriceStackView()
    
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
        
        /// 현재는 dummyData로 '15분 이용 중'을 보여주고 있으나
        /// 대여하기 상황에서는 '사용가능'
        /// 반납하기 상황에서는 'OO분 이용 중' 으로 보여주면 될 것 같습니다.
        /// makeAttributedString 메서드 사용법은 본 메서드에 작성되어 있습니다.
        usingTimeLabel.do {
            let text = "15분 이용 중"
            let attributedText = NSMutableAttributedString.makeAttributedString(
                text: text,
                highlightedParts: [
                    ("15분", .black, UIFont.systemFont(ofSize: 30, weight: .bold)),
                    ("이용 중", .black, UIFont.systemFont(ofSize: 30, weight: .regular))
                ]
            )
            $0.attributedText = attributedText
            $0.textAlignment = .center
            $0.textColor = .black
        }
        
    }
    
    // MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
        self.addSubviews(pobyImageView, batteryImageView, batteryLabel, priceStackView, usingTimeLabel)
        
        pobyImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(25)
            $0.width.equalTo(75)
            $0.height.equalTo(pobyImageView.snp.width).multipliedBy(1.5)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        priceStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalTo(pobyImageView)
        }
        
        usingTimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.bottom.equalTo(priceStackView.snp.top).offset(-5)
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
