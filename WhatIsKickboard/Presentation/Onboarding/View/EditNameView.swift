//
//  EditNameView.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/29/25.
//

import UIKit
import RxSwift

// MARK: - BaseView
final class EditNameView: BaseView {
    
    // MARK: - Components
    private let titleLabel = UILabel()
    private let titleImageView = UIImageView()
    private let titleLogoTitleView = UIImageView()
    private let nameTextField = UITextField()
    private let confirmButton = CustomSubmitButton()
    
    // MARK: - StackView Components
    private let inputStackView = UIStackView()
    
    // MARK: - Custonm Components
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
            $0.text = "이름을 불러봐 ~"
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
        
        // 이름
        nameTextField.do {
            $0.placeholder = "이름"
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 25
            $0.layer.masksToBounds = true
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
            $0.leftViewMode = .always
        }
        
        // 확인 버튼
        confirmButton.do {
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
        
        // 이메일 + 비밀번호 + 로그인 + (안내 + 회원가입)
        inputStackView.do {
            $0.axis = .vertical
            $0.spacing = 20
            $0.alignment = .center
            $0.addArrangedSubviews(nameTextField, nameTextField, confirmButton)
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
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints {
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
    var getNameTextField: UITextField {
        nameTextField
    }
    
    var getConfirmButton: UIButton {
        confirmButton
    }
}
