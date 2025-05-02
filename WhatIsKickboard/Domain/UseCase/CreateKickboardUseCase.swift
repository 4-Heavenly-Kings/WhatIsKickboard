//
//  CreateKickboardUseCase.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

protocol CreateKickboardUseCase {
    func execute(latitude: Double, longitude: Double, battery: Int, address: String) -> Single<UUID>
}
