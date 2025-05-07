//
//  DeclareKickboardRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/5/25.
//

import Foundation
import OSLog

final class DeclareKickboardRepository: DeclareKickboardRepositoryInterface {
    
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "DeclareKickboardRepository")
    
    func declareKickboard(id: UUID) async throws {
        do {
            try await KickboardPersistenceManager.declaredKickboard(id: id)
        } catch {
            throw error
        }
    }
}
