//
//  PaddingLabel.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//


import UIKit

final class PaddingLabel: UILabel {

    // 원하는 만큼 패딩 설정
    var textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    init(text: String,
         textColor: UIColor = .black,
         font: UIFont = .systemFont(ofSize: 15, weight: .bold),
         backgroundColor: UIColor = .systemBackground,
         textInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = font
        self.backgroundColor = backgroundColor
        self.textInsets = textInsets
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 텍스트가 그려질 때 패딩 적용
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    // intrinsicContentSize (레이아웃 사이즈 계산)에도 패딩 적용
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }

    // 사이즈 조정할 때도 패딩 적용
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = super.sizeThatFits(size)
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }
}
