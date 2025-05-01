//
//  ListRepository.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 5/1/25.
//

import Foundation

import RxSwift

final class ListRepository: ListRepositoryInterface {
    func getKickboardList() -> Single<[Kickboard]> {
        KickboardPersistenceManager.getKickboardList()
    }
    
    func getKickboardRideList(userId: UUID) -> Single<[KickboardRide]> {
        return KickboardPersistenceManager.getKickboardRideList(userId: userId)
    }
}
