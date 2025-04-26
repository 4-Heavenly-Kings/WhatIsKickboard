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
    
    /// context를 받아 저장하는 비동기 함수
    static func saveContext(_ context: NSManagedObjectContext, _ message: String) async throws {
        guard context.hasChanges else { return }
        do {
            try await context.perform {
                print("CoreData 저장 성공")
                try context.save()
            }
        } catch {
            print("CoreData \(message) 실패: \(error.localizedDescription)")
            throw error
        }
    }
}
