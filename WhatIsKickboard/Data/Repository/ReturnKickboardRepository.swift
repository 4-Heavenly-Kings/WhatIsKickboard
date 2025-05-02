//
//  ReturnKickboardRepository.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

final class ReturnKickboardRepository: ReturnKickboardRepositoryInterface {
    func returnKickboard(
        latitude: Double,
        longitude: Double,
        battery: Int,
        imagePath: String,
        address: String
    ) -> Single<Void> {
        return Single.create { single in
            Task {
                do {
                    let id = try KickboardPersistenceManager.getCurrentUserId()
                    try await KickboardPersistenceManager.returnKickboard(
                        id: id,
                        latitude: latitude,
                        longitude: longitude,
                        battery: battery,
                        imagePath: imagePath,
                        address: address
                    )
                    single(.success(()))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
