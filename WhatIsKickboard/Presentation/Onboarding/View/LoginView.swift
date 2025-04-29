//
//  LoginView.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/29/25.
//

import UIKit
import RxSwift

// MARK: - LoginView
final class LoginView: BaseView {
    
    // MARK: - Components
    private let titleLabel = UILabel()
    private let titleImageView = UIImageView()
    private let titleLogoTitleView = UIImageView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let announcementLabel = UILabel()
    private let navigationSignInButton = UIButton()
    
    // MARK: - StackView Components
    private let inputStackView = UIStackView()
    private let navigationStackView = UIStackView()
    
    // MARK: - Custom Components
    private var customAlertView: CustomAlertView?
    private var disposeBag = DisposeBag()
    
    // MARK: - Style
    override func setStyles() {
        
        backgroundColor = UIColor(hex: "F5F6F8", alpha: 1.0)
        overrideUserInterfaceStyle = .light
        
        addSubviews(titleLabel,
                    titleImageView,
                    titleLogoTitleView,
                    inputStackView)
        
        
        // 타이틀 라벨
        titleLabel.do {
            $0.text = "지금 바로 빌려봐 ~"
            $0.font = .jalnan2(32)
        }
        
        // 포비하이
        titleImageView.do {
            $0.image = UIImage(named: "PobyHi")
            $0.contentMode = .scaleAspectFit
        }
        
        // 로고
        titleLogoTitleView.do {
            $0.image = UIImage(named: "SplashTitle")
            $0.contentMode = .scaleAspectFit
        }
        
        // 이메일
        emailTextField.do {
            $0.placeholder = "이메일"
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 25
            $0.layer.masksToBounds = true
            $0.keyboardType = .emailAddress
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
            $0.leftViewMode = .always
        }
        
        // 비밀번호
        passwordTextField.do {
            $0.placeholder = "비밀번호"
            $0.isSecureTextEntry = true
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 25
            $0.layer.masksToBounds = true
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
            $0.leftViewMode = .always
        }
        
        // 로그인 버튼
        loginButton.do {
            $0.setTitle("로그인", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
        
        // 안내 라벨
        announcementLabel.do {
            $0.text = "아직 회원이 아니라면?"
            $0.textColor = .systemGray
        }
        
        // 회원가입 버튼
        navigationSignInButton.do {
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            $0.setTitle("회원가입하기", for: .normal)
            $0.setTitleColor(.systemGray, for: .normal)
        }
        
        // 안내 + 회원가입
        navigationStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.addArrangedSubviews(announcementLabel, navigationSignInButton)
        }
        
        // 이메일 + 비밀번호 + 로그인 + (안내 + 회원가입)
        inputStackView.do {
            $0.axis = .vertical
            $0.spacing = 20
            $0.alignment = .center
            $0.addArrangedSubviews(emailTextField, passwordTextField, loginButton, navigationStackView)
        }
        
    }
    
    // MARK: - Auoto Layout
    override func setLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(100)
            $0.centerX.equalToSuperview()
        }
        
        titleImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(36)
            $0.width.equalTo(140)
            $0.height.equalTo(179)
            $0.centerX.equalToSuperview()
        }
        
        titleLogoTitleView.snp.makeConstraints {
            $0.top.equalTo(titleImageView.snp.bottom)
            $0.width.equalTo(200)
            $0.height.equalTo(86)
            $0.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.width.equalToSuperview()
        }
        
        inputStackView.snp.makeConstraints {
            $0.top.equalTo(titleLogoTitleView.snp.bottom).offset(72)
            $0.horizontalEdges.equalToSuperview().inset(45)
            $0.centerX.equalToSuperview()
        }
    }
    
    /// Alert 표시 
    func showAlert(text: String) {
        customAlertView = CustomAlertView(frame: .zero, alertType: .emailFailed)
        
        guard let customAlertView else { return }
        addSubview(customAlertView)
        
        customAlertView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        customAlertView.configure(name: text)
        
        customAlertView.getSubmitButton().rx.tap
            .bind(with: self){ owner, _  in
                customAlertView.removeFromSuperview()
                owner.customAlertView = nil
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: 컴포넌트 접근시
    var getEmailTextField: UITextField {
        emailTextField
    }
    
    var getPasswordTextField: UITextField {
        passwordTextField
    }
    
    var getloginButton: UIButton {
        loginButton
    }
}
