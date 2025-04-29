//
//  MyPageView.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class MyPageView: BaseView {
    
    let usingKickboardView = UsingKickboardView()
    let pobyGreetingView = PobyGreetingView()
    let dividingLine = UIView()
    let myPageStackView = MyPageStackView()
    let priceStackView = PriceStackView()
    let withDrawalButton = UIButton()
    
    override func setStyles() {
        super.setStyles()
        
        self.backgroundColor = .systemBackground
        
        dividingLine.do {
            $0.backgroundColor = .black
        }
        
        withDrawalButton.do {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 15, weight: .bold),
                .foregroundColor: UIColor.gray,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.gray
            ]
            
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString(NSAttributedString(string: "회원탈퇴", attributes: attributes))
            config.baseForegroundColor = .gray
            
            $0.configuration = config
            $0.contentHorizontalAlignment = .center
        }
        
        self.addSubviews(pobyGreetingView, usingKickboardView, dividingLine, myPageStackView, withDrawalButton)
        
    }
    
    override func setLayout() {
        super.setLayout()
        
        pobyGreetingView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
//        usingKickboardView.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide)
//            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
//        }
        
        dividingLine.snp.makeConstraints {
            $0.top.equalTo(pobyGreetingView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(1)
        }
        
        myPageStackView.snp.makeConstraints {
            $0.top.equalTo(dividingLine.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        withDrawalButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
            $0.bottom.equalToSuperview().offset(-105 - 16)
        }
        
    }
}
