//
//  FeeLabelView.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import UIKit

import Then
import SnapKit

final class FeeLabelView: BaseView {
    
    // MARK: - UI Components

    private let baseLabel = UILabel()
    private let baseFeeLabel = UILabel()
    private let extralLabel = UILabel()
    private let extralFeeLabel = UILabel()
    
    // MARK: - Set UIComponents

    override func setStyles() {
        baseLabel.do {
            $0.text = "기본 요금"
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.textColor = UIColor(hex: "#000000")
        }
        
        baseFeeLabel.do {
            $0.text = "500원"
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = UIColor(hex: "#868686")
        }
        
        extralLabel.do {
            $0.text = "추가 요금"
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.textColor = UIColor(hex: "#000000")
        }
        
        extralFeeLabel.do {
            $0.text = "2,200원"
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = UIColor(hex: "#868686")
        }
    }
    
    // MARK: - Layout Helper

    override func setLayout() {
        addSubviews(baseLabel, baseFeeLabel, extralLabel, extralFeeLabel)
        
        baseLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        baseFeeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(baseLabel.snp.centerY)
        }
        
        extralLabel.snp.makeConstraints {
            $0.top.equalTo(baseLabel.snp.bottom).offset(31)
            $0.leading.equalToSuperview()
        }
        
        extralFeeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(extralLabel.snp.centerY)
        }
    }
    
    // MARK: - Methods

    func configure(extraFee: String) {
        extralFeeLabel.text = "\(extraFee)원"
    }
    
}
