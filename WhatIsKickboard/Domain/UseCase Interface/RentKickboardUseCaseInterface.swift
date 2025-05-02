//
//  RentKickboardUseCaseInterface.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/2/25.
//

import Foundation

import RxSwift

protocol RentKickboardUseCaseInterface {
    func execute(id: UUID, latitude: Double, longitude: Double, address: String)
}
