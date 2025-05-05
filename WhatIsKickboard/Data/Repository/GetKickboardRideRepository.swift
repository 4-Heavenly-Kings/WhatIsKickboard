//
//  GetKickboardRideRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/5/25.
//

import Foundation

import RxSwift

final class GetKickboardRideRepository: GetKickboardRideRepositoryInterface {
    func getKickboardRide(id: UUID) -> Single<KickboardRide> {
        return KickboardPersistenceManager.getKickboardRide(id: id)
    }
}
