//
//  GetKickboardListRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/5/25.
//

import Foundation

import RxSwift

final class GetKickboardListRepository: GetKickboardListRepositoryInterface {
    func getKickboardList() -> Single<[Kickboard]> {
        KickboardPersistenceManager.getKickboardList()
    }
}
