//
//  LoginViewModel.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/29/25.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - LoginViewModel
final class LoginViewModel: ViewModelProtocol {
    
    // MARK: - VC에서 방출하는 이벤트 액션 정의
    enum Action {
        case didTapLoginButton(email: String, password: String)
    }
    
    // MARK: - 상태관리 프로퍼티
    struct State {
        fileprivate(set) var actionSubject = PublishSubject<Action>()
        
        fileprivate(set) var loginSuccess = PublishRelay<User>()
        fileprivate(set) var loginError = PublishRelay<Error>()
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
                case let .didTapLoginButton(email, password):
                    owner.login(email: email, password: password)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action에 따른 이벤트
    
    /// 로그인
    private func login(email: String, password: String) {
        // 유효성 검사 통과 후 실행
        guard textFieldValidation(email: email, password: password) else { return }
        
        UserPersistenceManager.login(email, password)
            .subscribe(with: self, onSuccess: { owner, user in
                owner.state.loginSuccess.accept(user)
            }, onFailure: { owner, error in
                owner.state.loginError.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 내부에서만 동작되는 메서드 분리
extension LoginViewModel {
    
    /// 텍스트 필드 유효성 검사
    private func textFieldValidation(email: String, password: String) -> Bool {
        if email.isEmpty {
            state.loginError.accept(UserPersistenceError.emailTextFieldIsEmpty)
            return false
        } else if password.isEmpty {
            state.loginError.accept(UserPersistenceError.passwordTextFieldIsEmpty)
            return false
        }
        return true
    }
}
