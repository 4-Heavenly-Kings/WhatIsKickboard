//
//  GetKickboardRideUseCase.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/5/25.
//

import Foundation

import RxSwift

final class GetKickboardRideUseCase: GetKickboardRideUseCaseInterface {
    
    let repository: GetKickboardRideRepository
    
    init(repository: GetKickboardRideRepository) {
        self.repository = repository
    }
    
    func getKickboardRide(id: UUID) -> Single<KickboardRide> {
        return repository.getKickboardRide(id: id)
    }
}
