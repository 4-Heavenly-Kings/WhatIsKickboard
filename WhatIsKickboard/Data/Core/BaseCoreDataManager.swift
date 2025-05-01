//
//  BaseCoreDataInterface.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/26/25.
//

import Foundation
import CoreData

// MARK: - BaseCoreDataManager
/// CoreData를 사용하기 위해 필요한 기본 Interface
class BaseCoreDataManager {
    
    let context = CoreDataStack.shared.context
    
    /// context를 받아 저장하는 비동기 함수
    func saveContext(_ message: String) async throws {
        guard context.hasChanges else { return }
        do {
            try await context.perform {
                print("CoreData \(message) 성공")
                try self.context.save()
            }
        } catch {
            print("CoreData \(message) 실패: \(error.localizedDescription)")
            throw error
        }
    }
}
