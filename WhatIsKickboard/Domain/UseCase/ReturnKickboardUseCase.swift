//
//  ReturnKickboardUseCase.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

final class ReturnKickboardUseCase: ReturnKickboardUseCaseInterface {
    private let repository: ReturnKickboardRepositoryInterface

    init(repository: ReturnKickboardRepositoryInterface) {
        self.repository = repository
    }

    func execute(
        latitude: Double,
        longitude: Double,
        battery: Int,
        imagePath: String,
        address: String
    ) -> Single<Void> {
        return repository.returnKickboard(
            latitude: latitude,
            longitude: longitude,
            battery: battery,
            imagePath: imagePath,
            address: address
        )
    }
}
