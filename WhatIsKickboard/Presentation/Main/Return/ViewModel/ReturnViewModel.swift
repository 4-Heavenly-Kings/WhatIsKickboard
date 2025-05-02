//
//  ReturnViewModel.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 4/28/25.
//

import Foundation

import RxSwift
import RxRelay

final class ReturnViewModel: ViewModelProtocol {

    enum Action {
        case returnKickboard(
            latitude: Double,
            longitude: Double,
            battery: Int,
            imagePath: String,
            address: String
        )
    }

    struct State {
        let success = PublishRelay<Void>()
        let error = PublishRelay<Error>()
    }

    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    
    private let returnKickboardUseCaseInterface: ReturnKickboardUseCaseInterface

    init(returnKickboardUseCaseInterface: ReturnKickboardUseCaseInterface) {
        self.returnKickboardUseCaseInterface = returnKickboardUseCaseInterface
        bind()
    }
    
    let state = State()
    let disposeBag = DisposeBag()

    private func bind() {
        actionSubject
            .subscribe(onNext: { [weak self] action in
                guard let self else { return }
                switch action {
                case let .returnKickboard(latitude, longitude, battery, imagePath, address):
                    self.handleReturnKickboard(
                        latitude: latitude,
                        longitude: longitude,
                        battery: battery,
                        imagePath: imagePath,
                        address: address
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func handleReturnKickboard(
        latitude: Double,
        longitude: Double,
        battery: Int,
        imagePath: String,
        address: String
    ) {
        returnKickboardUseCaseInterface.execute(
            latitude: latitude,
            longitude: longitude,
            battery: battery,
            imagePath: imagePath,
            address: address
        )
        .subscribe(onSuccess: { [weak self] in
            self?.state.success.accept(())
        }, onFailure: { [weak self] error in
            self?.state.error.accept(error)
        })
        .disposed(by: disposeBag)
    }
    

}
