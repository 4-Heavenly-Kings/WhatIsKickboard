//
//  ReturnStackView.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import UIKit

import Then
import SnapKit

final class ReturnStackView: UIStackView {
    
    // MARK: - UI Components
    
    private let totalTimeLabel = UILabel()
    private let subStackView = UIStackView()
    private let batteryLabel = UILabel()
    private let totalFeeLabel = UILabel()
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
        setLayout()
    }
    
    // MARK: - Set UIComponents
    
    private func setStyles() {
        axis = .vertical
        spacing = 25
        alignment = .trailing
        
        totalTimeLabel.do {
            $0.text = "이용시간: 22분"
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.textColor = UIColor(hex: "#000000")
        }
        
        subStackView.do {
            $0.axis = .vertical
            $0.spacing = 5
            $0.alignment = .trailing
        }
        
        batteryLabel.do {
            $0.text = "배터리 55%"
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = UIColor(hex: "#000000")
        }
        
        totalFeeLabel.do {
            $0.text = "총금액: 2,700원"
            $0.font = .systemFont(ofSize: 36, weight: .bold)
            $0.textColor = UIColor(hex: "#000000")
        }
    }
    
    // MARK: - Layout Helper
    
    private func setLayout() {
        addArrangedSubviews(totalTimeLabel, subStackView)
        subStackView.addArrangedSubviews(batteryLabel, totalFeeLabel)
    }
    
    // MARK: - Methods
    
    func configure(time: Int, battery: Int, fee: String) {
        totalTimeLabel.text = "이용시간: \(time)분"
        batteryLabel.text = "배터리 \(battery)%"
        totalFeeLabel.text = "총금액: \(fee)원"
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
