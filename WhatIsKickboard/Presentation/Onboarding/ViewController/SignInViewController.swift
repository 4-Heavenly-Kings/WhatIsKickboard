//
//  SignUpViewController.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import UIKit

// MARK: - RegisterViewController
final class SignInViewController: BaseViewController {
    
    // MARK: - Components
    private let signInView = SignInView()
    private let viewModel = SignInViewModel()
    
    override func loadView() {
        view = signInView
    }
    
    override func bindViewModel() {
        
        // MARK: - 방출 이벤트
        /// 회원가입 버튼 이벤트 방출
        signInView.getloginButton.rx.tap
             .withUnretained(self)
             .map { owner, _ in
                 let email = owner.signInView.getEmailTextField.text ?? ""
                 let password = owner.signInView.getPasswordTextField.text ?? ""
                 let passwordConfirm = owner.signInView.getPasswordConfirmTextField.text ?? ""
                 return (owner, (email, password, passwordConfirm))
             }
             .bind { owner, data in
                 let (email, password, passwordConfirm) = data
                 owner.viewModel.action.onNext(.didTapSignInButton(email: email, password: password, passwordConfirm: passwordConfirm))
             }
             .disposed(by: disposeBag)
        
        /// 로그인 뷰 이동
        signInView.getNavigationLogInButton.rx.tap
            .subscribe(with: self) { owner, _ in
                guard let presenter = owner.presentingViewController else { return }

                owner.dismiss(animated: true) {
                    let vc = LoginViewController()
                    vc.modalPresentationStyle = .fullScreen
                    presenter.present(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - 구독 이벤트
        /// 회원가입 성공 이벤트 구독
        viewModel.state.signInSuccess
            .subscribe(with: self, onNext: { owner, user in
                guard let presenter = owner.presentingViewController else { return }

                owner.dismiss(animated: true) {
                    let vc = EditNameViewController()
                    vc.user = user
                    vc.modalPresentationStyle = .fullScreen
                    presenter.present(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        /// 회원가입 실패 이벤트 구독
        viewModel.state.signInError
            .subscribe(with: self, onNext: { owner, error in
                guard let error = error as? UserPersistenceError else { return }
                owner.signInView.showAlert(text: error.rawValue)
            })
            .disposed(by: disposeBag)
     }
}
