//
//  CreateKickboardRepository.swift
//  WhatIsKickboard
//
//  Created by 천성우 on 5/1/25.
//

import Foundation

import RxSwift

final class CreateKickboardRepository: CreateKickboardRepositoryInterface {
    func createKickboard(latitude: Double, longitude: Double, battery: Int, address: String) -> Single<UUID> {
        return Single<UUID>.create { single in
            Task {
                do {
                    let id = try await KickboardPersistenceManager.createKickboard(
                        latitude: latitude,
                        longitude: longitude,
                        battery: battery,
                        address: address
                    )
                    single(.success(id))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
