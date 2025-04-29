//
//  BaseView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class BaseView: UIView {
    
    private lazy var viewName = self.className
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
        setLayout()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        print("🧵 \(viewName) has been successfully Removed")
    }
    
    /// View 의 Style 을 set 합니다.
    func setStyles() {}
    /// View 의 Layout 을 set 합니다.
    func setLayout() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    /// 원하는 단어 부분만 color와 font를 지정해줄 수 있는 메서드
    /// 사용방법
    /*
     makeAttributedString(
         text: text,
         highlightedParts: [
             ("15분", .black, UIFont.systemFont(ofSize: 30, weight: .bold)),
             ("이용 중", .black, UIFont.systemFont(ofSize: 30, weight: .regular))
         ]
     )
     지정해주고자 하는 내용과 텍스트 컬러, 폰트를 지정해주면 됩니다.
     */
    func makeAttributedString(text: String, highlightedParts: [(substring: String, color: UIColor, font: UIFont)]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        highlightedParts.forEach { part in
            let range = (text as NSString).range(of: part.substring)
            attributedString.addAttribute(.foregroundColor, value: part.color, range: range)
            attributedString.addAttribute(.font, value: part.font, range: range)
        }
        return attributedString
    }
}
