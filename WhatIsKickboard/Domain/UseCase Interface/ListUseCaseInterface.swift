//
//  ListUseCaseInterface.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 5/1/25.
//

import Foundation

import RxSwift

protocol ListUseCaseInterface {
    func getKickboardList() -> Single<[Kickboard]>
    func getKickboardRideList(userId: UUID) -> Single<[KickboardRide]>
}
