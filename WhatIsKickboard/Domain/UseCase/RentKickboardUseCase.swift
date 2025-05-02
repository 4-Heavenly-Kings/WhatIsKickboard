//
//  RentKickboardUseCase.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/2/25.
//

import Foundation

import RxSwift

final class RentKickboardUseCase: RentKickboardUseCaseInterface {
    private let repository: RentKickboardRepositoryInterface

    init(repository: RentKickboardRepositoryInterface) {
        self.repository = repository
    }

    func execute(id: UUID, latitude: Double, longitude: Double, address: String) {
        return repository.rentKickboard(
            id: id,
            latitude: latitude,
            longitude: longitude,
            address: address
        )
    }
}
