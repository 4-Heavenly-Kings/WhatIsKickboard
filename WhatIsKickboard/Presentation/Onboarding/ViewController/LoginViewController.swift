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
        
        // MARK: - 방출 이벤트
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
        
        /// 회원 가입 뷰 이동
        loginView.getNavigationSignInButton.rx.tap
            .subscribe(with: self) { owner, _ in
                guard let presenter = owner.presentingViewController else { return }

                owner.dismiss(animated: true) {
                    let vc = SignInViewController()
                    vc.modalPresentationStyle = .fullScreen
                    presenter.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - 구독 이벤트
        /// 로그인 성공 이벤트 구독
        viewModel.state.loginSuccess
            .subscribe(with: self) { owner, user in
                guard let presenter = owner.presentingViewController else { return }
                owner.dismiss(animated: true) {
                    guard user.role == "GUEST" else { return }
                        
                    let vc = EditNameViewController()
                    vc.user = user
                    vc.modalPresentationStyle = .fullScreen
                    presenter.present(vc, animated: true)
                }
            }
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
