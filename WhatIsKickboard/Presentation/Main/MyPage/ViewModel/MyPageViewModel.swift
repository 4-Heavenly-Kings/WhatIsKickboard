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
        case viewDidLoad
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
                case .viewDidLoad:
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
    
    func logoutProgress() {
        state.accessLogout.accept(())
    }
    
    func withDrawalProgress() {
        // 회원탈퇴 비즈니스 로직 처리 필요
        state.accessWithDrawal.accept(())
    }
}
