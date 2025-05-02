//
//  ModifyViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/30/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

// MARK: - View Life Cycle
final class ModifyViewController: BaseViewController {
        
    // MARK: - Components
    private let modifyView = ModifyView()
    private var customAlertView: CustomAlertView?
    
    // MARK: - Properties
    private var modityType: ModifyType
    private let modifyViewModel: ModifyViewModel
    
    init(modityType: ModifyType, modifyViewModel: ModifyViewModel) {
        self.modityType = modityType
        self.modifyViewModel = modifyViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        view = modifyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUIEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func bindUIEvents() {
        modifyView.navigationBarView.getBackButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
                print("did Tap back Button")
            }
            .disposed(by: disposeBag)
        
        modifyView.navigationBarView.getRightButton().rx.tap
            .bind(with: self) { owner, _ in
                print("저장버튼")
                switch owner.modityType {
                case .name:
                    let nameText = owner.modifyView.modifyStackView.modifyTextFiled.text ?? ""
                    owner.modifyViewModel.action.onNext(.name(nameText))
                case .password:
                    let passwordText = owner.modifyView.modifyStackView.modifyTextFiled.text ?? ""
                    let passwordCheckText = owner.modifyView.modifyStackView.modifyCheckTextFiled.text ?? ""
                    owner.modifyViewModel.action.onNext(.password(passwordText, passwordCheckText))
                case .withdrawal:
                    let passwordText = owner.modifyView.modifyStackView.modifyTextFiled.text ?? ""
                    let passwordCheckText = owner.modifyView.modifyStackView.modifyCheckTextFiled.text ?? ""
                    owner.modifyViewModel.action.onNext(.withdrawal(passwordText, passwordCheckText))
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        modifyViewModel.state.nameStatus
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                print("유저 이름이 정상적으로 수정되었습니다.")
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        modifyViewModel.state.passwordStatus
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                print("유저 비밀번호가 정상적으로 수정되었습니다.")
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        modifyViewModel.state.withDrawalStatus
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                print("유저 회원탈퇴가 정상적으로 수행되었습니다.")
                SceneDelegate.switchToSplash()
            }
            .disposed(by: disposeBag)
        
        modifyViewModel.state.errorMessage
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, message in
                owner.showModifyAlert(message)
            }
            .disposed(by: disposeBag)
    }

    override func setStyles() {
        switch modityType {
        case .name:
            break
        case .password, .withdrawal:
            modifyView.modifyStackView.modifyTextFiled.do {
                $0.keyboardType = .default
                $0.isSecureTextEntry = true
            }
            
            modifyView.modifyStackView.modifyCheckTextFiled.do {
                $0.keyboardType = .default
                $0.isSecureTextEntry = true
            }
        }
        
        modifyView.navigationBarView.configure(
            title: modityType.navigationTitle,
            showsRightButton: true,
            rightButtonTitle: modityType.rightBarButtonTitle)
        
        modifyView.modifyStackView.configure(modityType)
    }
    
    override func setLayout() {

    }
    
    private func showModifyAlert(_ message: String) {
        let alert = CustomAlertView(frame: .zero, alertType: .failureUserModify)
        view.addSubview(alert)
        
        alert.configure(name: message)
        
        alert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alert.getSubmitButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.dismissAlertView(alert)
            }
            .disposed(by: disposeBag)
        
        alert.getCancelButton().rx.tap
            .bind(with: self) { owner, _ in
                owner.dismissAlertView(alert)
            }
            .disposed(by: disposeBag)

        self.customAlertView = alert
    }
    
    private func dismissAlertView(_ alert: CustomAlertView) {
        alert.removeFromSuperview()
        self.customAlertView = nil
        self.tabBarController?.tabBar.isHidden = true
    }
}
