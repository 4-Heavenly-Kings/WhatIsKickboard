//
//  MyRegisterKickboardTableViewCell.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import UIKit

import SnapKit
import Then

//MARK: - MyRegisterKickboardTableViewCell
final class MyRegisterKickboardTableViewCell: BaseTableViewCell {
    
    //MARK: - Components
    /// 배터리 Image
    let batteryImage = UIImageView()
    /// 킥보드 상태 Label
    let kickboardStatusLabel = UILabel()
    /// 킥보드 UUID
    let uuidLabel = UILabel()
    /// 배터리 상태 Label
    let battryStatusLabel = UILabel()
    /// 등록장소 Label
    let registerLocationLabel = UILabel()
    /// UUID + 배터리 상태 + 등록장소 StackView
    let stackView = UIStackView()
    
    //MARK: - Styles
    override func setStyles() {
        super.setStyles()
        
        batteryImage.do {
            $0.image = UIImage(named: "KickboardMarker_Available")
            $0.contentMode = .scaleAspectFit
        }
        
        kickboardStatusLabel.do {
            $0.text = "사용 가능"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 12, weight: .bold)
            $0.textAlignment = .center
        }
        
        uuidLabel.do {
            $0.text = "FWE3MC4K"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 12, weight: .bold)
            $0.textAlignment = .center
        }
        
        battryStatusLabel.do {
            $0.text = "배터리 상태: 77%"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 15, weight: .bold)
            $0.textAlignment = .center
        }
        
        registerLocationLabel.do {
            $0.text = "등록장소: 서울특별시 강남구 강남대로 1234"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 5
            $0.alignment = .trailing
        }
        
    }
    
    //MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
        self.addSubviews(batteryImage, kickboardStatusLabel, stackView)
        stackView.addArrangedSubviews(uuidLabel, battryStatusLabel, registerLocationLabel)
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        batteryImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.verticalEdges.equalTo(kickboardStatusLabel)
            $0.width.equalTo(batteryImage.snp.height)
        }
        
        kickboardStatusLabel.snp.makeConstraints {
            $0.leading.equalTo(batteryImage.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
}
