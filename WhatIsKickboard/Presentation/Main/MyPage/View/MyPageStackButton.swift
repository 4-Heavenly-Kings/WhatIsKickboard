//
//  MyPageStackButton.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

final class MyPageStackButton: UIButton {
    
    init(title: String, titleColor: UIColor = .black, font: UIFont = .systemFont(ofSize: 15, weight: .bold)) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(title, attributes: .init([.font: font]))
        
        config.baseBackgroundColor = .systemBackground
        config.baseForegroundColor = titleColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        
        self.configuration = config
        self.backgroundColor = .systemBackground
        self.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.contentHorizontalAlignment = .leading
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
