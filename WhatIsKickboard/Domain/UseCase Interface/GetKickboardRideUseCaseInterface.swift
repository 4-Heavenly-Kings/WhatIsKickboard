//
//  GetKickboardRideUseCaseInterface.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/5/25.
//

import Foundation

import RxSwift

protocol GetKickboardRideUseCaseInterface {
    func getKickboardRide(id: UUID) -> Single<KickboardRide>
}
