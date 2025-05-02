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
                    let userId = try KickboardPersistenceManager.getCurrentUserId()
                    
                    let rideList = try await withCheckedThrowingContinuation { continuation in
                        _ = KickboardPersistenceManager.getKickboardRideList(userId: userId)
                            .subscribe(onSuccess: { rides in
                                continuation.resume(returning: rides)
                            }, onFailure: { error in
                                continuation.resume(throwing: error)
                            })
                    }

                    guard let currentRide = rideList.last else {
                        throw KickboardPersistenceError.rideNotFound
                    }

                    try await KickboardPersistenceManager.returnKickboard(
                        id: currentRide.kickboardId,
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
