//
//  RegisterViewModel.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift
import RxRelay

final class RegisterViewModel: ViewModelProtocol {

    enum Action {
        case createKickboard(RegisterUIModel, Int)
    }

    struct State {
        let success = PublishRelay<UUID>()
        let error = PublishRelay<Error>()
    }

    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    
    let state = State()
    let disposeBag = DisposeBag()
    
    private let createKickboardUseCase: CreateKickboardUseCase


    init(createKickboardUseCase: CreateKickboardUseCase) {
        self.createKickboardUseCase = createKickboardUseCase
        bind()
    }

    private func bind() {
        actionSubject
            .subscribe(onNext: { [weak self] action in
                guard let self else { return }
                switch action {
                case .createKickboard(let model, let battery):
                    self.createKickboard(model: model, battery: battery)
                }
            })
            .disposed(by: disposeBag)
    }

    private func createKickboard(model: RegisterUIModel, battery: Int) {
        createKickboardUseCase.execute(
            latitude: model.latitude,
            longitude: model.longitude,
            battery: battery,
            address: model.address
        )
        .subscribe(onSuccess: { [weak self] kickboardId in
            self?.state.success.accept(kickboardId)
        }, onFailure: { [weak self] error in
            self?.state.error.accept(error)
        })
        .disposed(by: disposeBag)
    }
}
