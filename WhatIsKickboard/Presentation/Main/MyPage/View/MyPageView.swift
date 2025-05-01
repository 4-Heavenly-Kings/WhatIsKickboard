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

//MARK: - MyPageView
final class MyPageView: BaseView {
    
    //MARK: - Components
    /// 포비의 인사 View (킥보드 이용 중 X)
    let pobyGreetingView = PobyGreetingView()
    /// 사용자 킥보드 이용 View
    let usingKickboardView = MyPageUsingKickboardView()
    /// 구분선
    let dividingLine = UIView()
    /// 이름 수정 ~ 로그아웃 StackView
    let myPageStackView = MyPageStackView()
    /// 기본요금, 분당요금 StackView
    let priceStackView = PriceStackView()
    /// 회원탈퇴 Button
    let withDrawalButton = UIButton()
    
    // MARK: - Styles
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
        
        usingKickboardView.isHidden = true
    }
    
    // MARK: - Layouts
    override func setLayout() {
        super.setLayout()
        
        self.addSubviews(pobyGreetingView, usingKickboardView, dividingLine, myPageStackView, withDrawalButton)
        
        pobyGreetingView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        usingKickboardView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
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
