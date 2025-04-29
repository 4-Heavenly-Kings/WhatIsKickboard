//
//  PriceStackView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

import Then

final class PriceStackView: UIStackView {
    
    let basicPrice = UILabel()
    let minutePrice = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// View 의 Style 을 set 합니다.
    func setStyles() {
        
        basicPrice.do {
            $0.text = "기본요금 500원"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        minutePrice.do {
            $0.text = "분당요금 100원"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        self.axis = .vertical
        self.alignment = .fill
        self.spacing = 3
        self.distribution = .fillEqually
        
        self.addArrangedSubviews(basicPrice, minutePrice)
    }
    
    /// View 의 Layout 을 set 합니다.
    func setLayout() {}
}
