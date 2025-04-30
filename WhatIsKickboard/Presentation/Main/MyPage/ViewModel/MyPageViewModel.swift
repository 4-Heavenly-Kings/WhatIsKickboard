//
//  MyPageViewModel.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/28/25.
//

import Foundation

import RxSwift
import RxRelay

final class MyPageViewModel: ViewModelProtocol {

    enum Action {
        case logoutAction
        case withDrawalAction
    }

    struct State {
        let accessLogout = PublishRelay<Void>()
        let accessWithDrawal = PublishRelay<Void>()
    }

    private let actionSubject = PublishSubject<Action>()
    
    var action: AnyObserver<Action> { actionSubject.asObserver() }

    let state = State()
    let disposeBag = DisposeBag()

    init() {
        bind()
    }

    private func bind() {
        actionSubject
            .subscribe(with: self) { owner, action in
                switch action {
                case .logoutAction:
                    owner.logoutProgress()
                case .withDrawalAction:
                    owner.withDrawalProgress()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func logoutProgress() {
        // 로그아웃 비즈니스 로직 처리 필요
        state.accessLogout.accept(())
    }
    
    private func withDrawalProgress() {
        // 회원탈퇴 비즈니스 로직 처리 필요
        state.accessWithDrawal.accept(())
    }
}
