//
//  LoginViewModel.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/29/25.
//

import Foundation
import RxSwift

// MARK: - LoginViewModel
final class LoginViewModel: ViewModelProtocol {
    
    // MARK: - VC에서 방출하는 이벤트 액션 정의
    enum Action {
        case didTapLoginButton
    }
    
    // MARK: - 상태관리 프로퍼티
    struct State {
        fileprivate(set) var actionSubject = PublishSubject<Action>()
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
                case .didTapLoginButton: owner.login()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func login() {
        
    }
}
