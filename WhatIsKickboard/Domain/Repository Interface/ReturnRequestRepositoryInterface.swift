//
//  ReturnRequestRepositoryInterface.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

protocol ReturnRequestRepositoryInterface {
    func getCurrentUser() -> Single<User>
    func getKickboard(id: UUID) -> Single<Kickboard>
    func getKickboardRide(id: UUID) -> Single<KickboardRide>
}
