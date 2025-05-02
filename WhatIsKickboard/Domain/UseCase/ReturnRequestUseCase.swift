//
//  ReturnRequestUseCase.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

/// 이거 파일명 수정
final class ReturnRequestUseCase: ReturnRequestUseCaseInterface {
    private let repository: ReturnRequestRepositoryInterface

    init(repository: ReturnRequestRepositoryInterface) {
        self.repository = repository
    }

    func getCurrentUser() -> Single<User> {
        repository.getCurrentUser()
    }

    func getKickboard(id: UUID) -> Single<Kickboard> {
        repository.getKickboard(id: id)
    }

    func getKickboardRide(id: UUID) -> Single<KickboardRide> {
        repository.getKickboardRide(id: id)
    }
}
