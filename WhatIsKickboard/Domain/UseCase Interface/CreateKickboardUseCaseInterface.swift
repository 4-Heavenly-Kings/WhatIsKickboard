//
//  CreateKickboardUseCaseInterface.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

final class CreateKickboardUseCaseInterface: CreateKickboardUseCase {
    private let repository: CreateKickboardRepositoryInterface

    init(repository: CreateKickboardRepositoryInterface) {
        self.repository = repository
    }

    func execute(latitude: Double, longitude: Double, battery: Int, address: String) -> Single<UUID> {
        return repository.createKickboard(
            latitude: latitude,
            longitude: longitude,
            battery: battery,
            address: address
        )
    }
}
