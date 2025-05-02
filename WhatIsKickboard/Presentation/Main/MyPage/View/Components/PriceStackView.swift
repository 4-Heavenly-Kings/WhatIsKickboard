//
//  PriceStackView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

import Then

//MARK: - PriceStackView
final class PriceStackView: UIStackView {
    
    //MARK: - Components
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
    
    // MARK: - Styles
    private func setStyles() {
        
        basicPrice.do {
            $0.text = "기본요금 500원"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 15, weight: .bold)
        }
        
        minutePrice.do {
            $0.text = "분당요금 100원"
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 15, weight: .bold)
        }
        
        self.axis = .vertical
        self.alignment = .fill
        self.spacing = 3
        self.distribution = .fillEqually
    }
    
    // MARK: - Layouts
    private func setLayout() {
        self.addArrangedSubviews(basicPrice, minutePrice)
    }
}
