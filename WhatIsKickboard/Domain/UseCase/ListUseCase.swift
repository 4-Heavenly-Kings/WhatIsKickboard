//
//  ListUseCase.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 5/1/25.
//

import Foundation

import RxSwift

final class ListUseCase: ListUseCaseInterface {
    
    let repository: ListRepository
    
    init(repository: ListRepository) {
        self.repository = repository
    }
    
    func getKickboardList() -> Single<[Kickboard]> {
        return repository.getKickboardList()
    }
    
    func getKickboardRideList(userId: UUID) -> Single<[KickboardRide]> {
        return repository.getKickboardRideList(userId: userId)
    }
    
}
