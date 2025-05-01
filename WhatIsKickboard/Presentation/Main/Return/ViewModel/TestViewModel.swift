//
//  TestViewModel.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift
import RxRelay

final class TestViewModel: ViewModelProtocol {

    enum Action {
        case requestReturn(kickboardId: UUID)
    }

    struct State {
        let kickboard = PublishRelay<Kickboard>()
        let user = PublishRelay<User>()
        let error = PublishRelay<Error>()
    }

    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }

    let state = State()
    let disposeBag = DisposeBag()

    private let returnRequestUseCase: ReturnRequestUseCase

    init(returnRequestUseCase: ReturnRequestUseCase) {
        self.returnRequestUseCase = returnRequestUseCase
        bind()
    }

    private func bind() {
        actionSubject
            .subscribe(onNext: { [weak self] action in
                guard let self else { return }
                switch action {
                case .requestReturn(let kickboardId):
                    self.handleReturnRequest(kickboardId: kickboardId)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func handleReturnRequest(kickboardId: UUID) {
        returnRequestUseCase.getCurrentUser()
            .flatMap { [weak self] user -> Single<(Kickboard, User)> in
                guard let self = self else {
                    return .error(NSError(domain: "ViewModel deallocated", code: -1))
                }
                return self.returnRequestUseCase.getKickboard(id: kickboardId)
                    .map { kickboard in (kickboard, user) }
            }
            .subscribe(onSuccess: { [weak self] kickboard, user in
                self?.state.kickboard.accept(kickboard)
                self?.state.user.accept(user)
            }, onFailure: { [weak self] error in
                self?.state.error.accept(error)
            })
            .disposed(by: disposeBag)
    }

}
