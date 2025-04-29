//
//  LoginViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

// MARK: - LoginViewController
final class LoginViewController: BaseViewController {
    
    // MARK: - Components
    private let loginView = LoginView()
    private let viewModel = LoginViewModel()
    
    
    override func loadView() {
        view = loginView
    }
    
    override func bindViewModel() {
        /// 로그인 버튼 이벤트 방출
        loginView.getloginButton.rx.tap
             .withUnretained(self)
             .map { owner, _ in
                 let email = owner.loginView.getEmailTextField.text ?? ""
                 let password = owner.loginView.getPasswordTextField.text ?? ""
                 return (owner, (email, password))
             }
             .bind { owner, data in
                 let (email, password) = data
                 owner.viewModel.action.onNext(.didTapLoginButton(email: email, password: password))
             }
             .disposed(by: disposeBag)
        
        /// 로그인 성공 이벤트 구독
        viewModel.state.loginSuccess
            .subscribe(with: self, onNext: { owner, event in
                let editNameVC = EditNameViewController()
                owner.navigationController?.pushViewController(editNameVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        /// 로그인 실패 이벤트 구독
        viewModel.state.loginError
            .subscribe(with: self, onNext: { owner, error in
                guard let error = error as? UserPersistenceError else { return }
                owner.loginView.showAlert(text: error.rawValue)
            })
            .disposed(by: disposeBag)
     }
}
