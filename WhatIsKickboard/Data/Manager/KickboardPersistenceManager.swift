//
//  KickboardPersistenceManager.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation
import CoreData

// MARK: - KickboardPersistenceManager
/// 킥보드정보 CRUD Manager
final class KickboardPersistenceManager: BaseCoreDataManager {
    
    /// 킥보드 리스트 조회
    static func getKickboardList() throws -> [Kickboard] {
        return try getKickboardListData().map { $0.toModel() }
    }
    
    /// 킥보드 조희
    static func getKickboard() -> Kickboard {
        return KickboardEntity(context: context).toModel()
    }
    
    /// 킥보드 등록
    static func createKickboard() {
        
    }
    
    /// 킥보드 대여
    static func rentKickboard() {
        
    }
    
    /// 킥보드 반납
    static func returnKickboard() {
        
    }
    
    /// 킥보드 신고
    static func declaredKickboard() {
        
    }
    
    /// 킥보드 삭제
    static func deleteKickboard() {
        
    }
}

// MARK: Extension + KickboardPersistenceManager
/// 데이터 및 데이터 리스트 Entity 추출
extension KickboardPersistenceManager {
    
    /// CoreData Persistence 저장소에서 킥보드 Entity 추출
    @discardableResult
    static private func getKickboardData(id: UUID) throws -> KickboardEntity {
        let request = NSFetchRequest<KickboardEntity>(entityName: KickboardEntity.className)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        guard let kickboard = try context.fetch(request).first else {
            print("해당 킥보드가 존재하지 않음")
            throw KickboardPersistenceError.kickboardNotFound
        }
        return kickboard
    }
    
    /// CoreData Persistence 저장소에서 킥보드 Entity 추출
    @discardableResult
    static private func getKickboardListData() throws -> [KickboardEntity] {
        let request = NSFetchRequest<KickboardEntity>(entityName: KickboardEntity.className)
        do {
            return try context.fetch(request)
        } catch {
            throw KickboardPersistenceError.fetchFaild
        }
    }
}
