//
//  LoginView.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/29/25.
//

import UIKit

// MARK: - LoginView
final class LoginView: BaseView {
    
    private let titleLabel = UILabel()
    private let titleImageView = UIImageView()
    private let titleLogoTitleView = UIImageView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let navigationSignInButton = UIButton()
    
    private let inputStackView = UIStackView()
    
    override func setStyles() {
        
        addSubviews(titleLabel,
                    titleImageView,
                    titleLogoTitleView,
                    inputStackView,
                    navigationSignInButton)
        
        
        titleLabel.do {
            $0.text = "지금 바로 빌려봐 ~"
            $0.font = .jalnan2(16)
        }
        
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
