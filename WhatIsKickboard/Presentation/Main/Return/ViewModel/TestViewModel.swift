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
        case requestReturn
    }

    struct State {
        let kickboardRide = PublishRelay<KickboardRide>()
        let user = PublishRelay<User>()
        let error = PublishRelay<Error>()
    }

    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }

    let state = State()
    let disposeBag = DisposeBag()

    private let returnRequestUseCase: ReturnRequestUseCase
    private var storedKickboardId: UUID?

    init(returnRequestUseCase: ReturnRequestUseCase) {
        self.returnRequestUseCase = returnRequestUseCase
        bind()
        Task {
            do {
                let id = try await KickboardPersistenceManager.createKickboard(
                    latitude: 37.1236,
                    longitude: 127.1236,
                    battery: 70,
                    address: "서울특별시 종로구 세종대로 175"
                )
                self.storedKickboardId = id
            } catch {
                print("⚠️ 테스트용 킥보드 저장 실패: \(error)")
            }
        }
    }

    private func bind() {
        actionSubject
            .subscribe(onNext: { [weak self] action in
                guard let self else { return }
                switch action {
                case .requestReturn:
                    self.handleReturnRequest()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func handleReturnRequest() {
        returnRequestUseCase.getCurrentUser()
            .flatMap { [weak self] user -> Single<(KickboardRide, User)> in
                guard let self = self else {
                    return .error(NSError(domain: "ViewModel deallocated", code: -1))
                }

                guard let rideId = user.currentKickboardRideId else {
                    return .error(NSError(domain: "No current ride ID", code: -2))
                }

                return self.returnRequestUseCase.getKickboardRide(id: rideId)
                    .map { ride in (ride, user) }
            }
            .subscribe(onSuccess: { [weak self] ride, user in
                self?.state.kickboardRide.accept(ride)
                self?.state.user.accept(user)
            }, onFailure: { [weak self] error in
                self?.state.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
    


}
