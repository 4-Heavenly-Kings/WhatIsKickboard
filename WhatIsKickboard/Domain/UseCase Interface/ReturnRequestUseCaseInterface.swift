//
//  ReturnRequestUseCaseInterface.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

final class ReturnRequestUseCaseInterface: ReturnRequestUseCase {
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
