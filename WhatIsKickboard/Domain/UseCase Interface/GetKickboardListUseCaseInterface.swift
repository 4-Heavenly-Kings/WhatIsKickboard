//
//  GetKickboardListUseCaseInterface.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/5/25.
//

import Foundation

import RxSwift

protocol GetKickboardListUseCaseInterface {
    func getKickboardList() -> Single<[Kickboard]>
}
