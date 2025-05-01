//
//  ReturnRequestRepositoryInterface.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

protocol ReturnRequestRepositoryInterface {
    func getKickboard(id: UUID) -> Single<Kickboard>
    func getCurrentUser() -> Single<User>
}
