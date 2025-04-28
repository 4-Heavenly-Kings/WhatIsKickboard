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
                print("CoreData \(message) 성공")
                try context.save()
            }
        } catch {
            print("CoreData \(message) 실패: \(error.localizedDescription)")
            throw error
        }
    }
    
    static func getUserData(id: UUID? = nil, email: String? = nil, context: NSManagedObjectContext) throws -> UserEntity {
        let request = NSFetchRequest<UserEntity>(entityName: UserEntity.className)
        
        if let id {
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        } else if let email {
            request.predicate = NSPredicate(format: "email == %@", email as CVarArg)
        }
        
        request.fetchLimit = 1
        
        guard let user = try context.fetch(request).first else {
            print("해당 유저가 존재하지 않음")
            throw UserPersistenceError.userNotFound
        }
        return user
    }
}
