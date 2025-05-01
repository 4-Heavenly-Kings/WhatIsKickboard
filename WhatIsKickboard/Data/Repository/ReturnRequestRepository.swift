//
//  ReturnRequestRepository.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

final class ReturnRequestRepository: ReturnRequestRepositoryInterface {
    func getKickboard(id: UUID) -> Single<Kickboard> {
        KickboardPersistenceManager.getKickboard(id: id)
    }

    func getCurrentUser() -> Single<User> {
        UserPersistenceManager.getUser()
    }
}
