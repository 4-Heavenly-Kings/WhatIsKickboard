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
        case viewWillAppear
        case logoutAction
        case withDrawalAction
    }

    struct State {
        let user = PublishSubject<User>()
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
                case .viewWillAppear:
                    owner.loadUser()
                case .logoutAction:
                    owner.logoutProgress()
                case .withDrawalAction:
                    owner.withDrawalProgress()
                }
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - Extension Private Methods
private extension MyPageViewModel {
    
    /// 유저정보 불러오기
    func loadUser() {
        UserPersistenceManager.getUser()
            .subscribe(with: self, onSuccess: { owner, user in
                owner.state.user.onNext(user)
            }, onFailure: { owner, error in
                owner.state.user.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    /// 로그아웃 처리하기
    func logoutProgress() {
        state.accessLogout.accept(())
    }
    
    /// 회원탈퇴 처리하기
    func withDrawalProgress() {
        state.accessWithDrawal.accept(())
    }
}
