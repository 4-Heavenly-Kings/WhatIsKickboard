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
    static func getKickboard(id: UUID) throws -> Kickboard {
        return try getKickboardData(id: id).toModel()
    }
    
    /// 킥보드 등록
    static func createKickboard(latitude: Double, longitude: Double, battery: Int) async throws {
        let status:String
        
        switch battery {
        case 0...10: status = "LOW_BATTERY"
        default: status = "ABLE"
        }
        
        let kickboard = KickboardEntity(context: context)
        kickboard.id = UUID()
        kickboard.latitude = latitude
        kickboard.longitude = longitude
        kickboard.battery = Int16(battery)
        kickboard.status = status
        
        try await saveContext("킥보드 등록")
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
    private static func getKickboardData(id: UUID) throws -> KickboardEntity {
        let request = NSFetchRequest<KickboardEntity>(entityName: KickboardEntity.className)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        guard let kickboard = try context.fetch(request).first else {
            print("해당 킥보드가 존재하지 않음")
            throw KickboardPersistenceError.kickboardNotFound
        }
        return kickboard
    }
    
    /// CoreData Persistence 저장소에서 킥보드 리스트 Entity 추출
    @discardableResult
    private static func getKickboardListData() throws -> [KickboardEntity] {
        let request = NSFetchRequest<KickboardEntity>(entityName: KickboardEntity.className)
        do {
            return try context.fetch(request)
        } catch {
            throw KickboardPersistenceError.fetchKickboardFaild
        }
    }
    
    /// CoreData Persistence 저장소에서 탑승 정보 Entity 추출
    @discardableResult
    private static func getRideData(id: UUID) throws -> RideEntity {
        let request = NSFetchRequest<RideEntity>(entityName: RideEntity.className)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        guard let kickboard = try context.fetch(request).first else {
            print("해당 탑승정보가 존재하지 않음")
            throw KickboardPersistenceError.rideNotFound
        }
        return kickboard
    }
    
    /// CoreData Persistence 저장소에서 탑승 정보 리스트 Entity 추출
    @discardableResult
    private static func getRideListData(userId: UUID) throws -> [RideEntity] {
        let request = NSFetchRequest<RideEntity>(entityName: RideEntity.className)
        request.predicate = NSPredicate(format: "user_id == %@", userId as CVarArg)
        
        do {
            let rides = try context.fetch(request)
            return rides.sorted { ($0.start_time ?? .distantPast) < ($1.start_time ?? .distantPast) }
        } catch {
            throw KickboardPersistenceError.fetchRideFaild
        }
    }
    
    /// CoreData Persistence 저장소에서 유저 Entity 추출
    @discardableResult
    static private func getUserData(id: UUID) throws -> UserEntity {
        let request = NSFetchRequest<UserEntity>(entityName: UserEntity.className)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        guard let kickboard = try context.fetch(request).first else {
            print("해당 유저가 존재하지 않음")
            throw KickboardPersistenceError.userNotFound
        }
        return kickboard
    }
    
    }
}
