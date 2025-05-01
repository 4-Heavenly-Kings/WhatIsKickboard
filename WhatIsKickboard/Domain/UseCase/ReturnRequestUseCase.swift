//
//  ReturnRequestUseCase.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

protocol ReturnRequestUseCase {
    func getCurrentUser() -> Single<User>
    func getKickboard(id: UUID) -> Single<Kickboard>
}
