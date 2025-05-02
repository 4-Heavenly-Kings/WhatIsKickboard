//
//  SignInViewModel.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/29/25.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - SinInViewModel
final class SignInViewModel: ViewModelProtocol {
    
    // MARK: - VC에서 방출하는 이벤트 액션 정의
    enum Action {
        case didTapSignInButton(email: String, password: String, passwordConfirm: String)
    }
    
    // MARK: - 상태관리 프로퍼티
    struct State {
        fileprivate(set) var actionSubject = PublishSubject<Action>()
        
        fileprivate(set) var signInSuccess = PublishRelay<User>()
        fileprivate(set) var signInError = PublishRelay<Error>()
    }
    
    // MARK: - Action -> Observer 생성
    var action: AnyObserver<Action> {
        state.actionSubject.asObserver()
    }
    
    var disposeBag = DisposeBag()
    var state = State()
    
    // MARK: - init시 이벤트에 따라 메서드 실행
    init() {
        state.actionSubject
            .subscribe(with: self){ owner, action in
                switch action {
                case let .didTapSignInButton(email, password, passwordConfirm):
                    owner.signIn(email: email, password: password, passwordConfirm: passwordConfirm)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action에 따른 이벤트
    
    /// 회원가입
    private func signIn(email: String, password: String, passwordConfirm: String) {
        // 유효성 검사 통과 후 실행
        guard textFieldValidation(email: email, password: password, passwordConfirm: passwordConfirm) else { return }
        
        UserPersistenceManager.createUser(email, password)
            .subscribe(with: self, onSuccess: { owner, user in
                owner.state.signInSuccess.accept(user)
            }, onFailure: { owner, error in
                owner.state.signInError.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 내부에서만 동작되는 메서드 분리
extension SignInViewModel {
    
    /// 텍스트 필드 유효성 검사
    private func textFieldValidation(email: String, password: String, passwordConfirm: String) -> Bool {
        if email.isEmpty {
            state.signInError.accept(UserPersistenceError.emailTextFieldIsEmpty)
            return false
        } else if password.isEmpty {
            state.signInError.accept(UserPersistenceError.passwordTextFieldIsEmpty)
            return false
        } else if passwordConfirm.isEmpty {
            state.signInError.accept(UserPersistenceError.fieldIsEmpty)
            return false
        } else if password != passwordConfirm {
            state.signInError.accept(UserPersistenceError.passwordIsWorng)
            return false
        }
        return true
    }
}
