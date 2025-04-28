//
//  ReturnView.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift

final class ReturnView: BaseView {
    
    // MARK: - UI Components
    
    private(set) var navigationBarView = CustomNavigationBarView()
    private(set) var imageView = UIImageView()
    private(set) var feeLabelView = FeeLabelView()
    private(set) var returnStackView = ReturnStackView()
    
    // MARK: - Set UIComponents

    override func setStyles() {
        navigationBarView.configure(title: "반납하기", showsRightButton: false, rightButtonTitle: nil)
        
        imageView.do {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = UIColor(hex: "#868686")
        }
    }
    
    // MARK: - Layout Helper
    
    override func setLayout() {
        addSubviews(navigationBarView, imageView, feeLabelView, returnStackView)
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * 400 / 440)
            $0.height.equalTo(UIScreen.main.bounds.height * 379 / 956)
        }
        
        feeLabelView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(25)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(UIScreen.main.bounds.height * 79 / 956)
        }
        
        returnStackView.snp.makeConstraints {
            $0.top.equalTo(feeLabelView.snp.bottom).offset(80)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
