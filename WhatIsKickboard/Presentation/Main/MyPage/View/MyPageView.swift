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
    let myPageStackView = UIStackView()
    let withDrawalButton = UIButton()
    
    override func setStyles() {
        super.setStyles()
        
        self.backgroundColor = .systemBackground
        
        self.addSubviews(usingKickboardView, pobyGreetingView, dividingLine, myPageStackView, withDrawalButton)
        
    }
    
    override func setLayout() {
        super.setLayout()
        
        pobyGreetingView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
    }
}
