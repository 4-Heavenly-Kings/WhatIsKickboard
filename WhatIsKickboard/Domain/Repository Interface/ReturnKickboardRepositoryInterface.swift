//
//  ReturnKickboardRepositoryInterface.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

protocol ReturnKickboardRepositoryInterface {
    func returnKickboard(
        latitude: Double,
        longitude: Double,
        battery: Int,
        imagePath: String,
        address: String
    ) -> Single<Void>
}
