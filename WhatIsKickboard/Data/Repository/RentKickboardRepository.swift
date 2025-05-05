//
//  RentKickboardRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/2/25.
//

import Foundation
import OSLog

import RxSwift

final class RentKickboardRepository: RentKickboardRepositoryInterface {
    
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "RentKickboardRepository")
    
    func rentKickboard(id: UUID, latitude: Double, longitude: Double, address: String) {
        Task {
            do {
                try await KickboardPersistenceManager.rentKickboard(id: id, latitude: latitude, longitude: longitude, address: address)
            } catch {
                os_log(.error, log: log, "\(error.localizedDescription)")
            }
        }
    }
}
