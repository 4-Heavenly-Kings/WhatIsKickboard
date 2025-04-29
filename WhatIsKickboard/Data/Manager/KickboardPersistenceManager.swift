//
//  KickboardPersistenceManager.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation
import CoreData
import RxSwift

// MARK: - KickboardPersistenceManager
/// 킥보드정보 CRUD Manager
final class KickboardPersistenceManager: BaseCoreDataManager {
    
    /// 킥보드 리스트 조회
    static func getKickboardList() -> Single<[Kickboard]> {
        return Single.create { single in
            do {
                let kickboards = try getKickboardListData().map { $0.toModel() }
                single(.success(kickboards))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }

    /// 킥보드 조회
    static func getKickboard(id: UUID) -> Single<Kickboard> {
        return Single.create { single in
            do {
                let kickboard = try getKickboardData(id: id).toModel()
                single(.success(kickboard))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    /// 킥보드 등록
    @discardableResult
    static func createKickboard(latitude: Double, longitude: Double, battery: Int) async throws -> UUID {
        let kickboard = KickboardEntity(context: context)
        let id = UUID()
        
        kickboard.id = id
        kickboard.latitude = latitude
        kickboard.longitude = longitude
        kickboard.battery = Int16(battery)
        kickboard.status = setStatus(battery: battery)
        
        try await saveContext("킥보드 등록")
        return id
    }
    
    /// 킥보드 대여
    static func rentKickboard(id: UUID, latitude: Double, longitude: Double) async throws {
        let userId = try getCurrentUserId()

        let user = try getUserData(id: userId)
        let kickboard = try getKickboardData(id: id)
        
        let ride = KickboardRideEntity(context: context)
        ride.id = UUID()
        ride.user_id = userId
        ride.kickboard_id = id
        ride.start_time = Date()
        ride.start_latitude = latitude
        ride.start_longitude = longitude
        ride.battery = kickboard.battery
        
        // ride와 kickboard/user를 연결
        ride.kickboard = kickboard
        ride.user = user
        
        // kickboard/user의 rides에 ride 추가
        kickboard.addToRides(ride)
        user.addToRides(ride)
        
        kickboard.status = "IMPOSSIBILITY"
        try await saveContext("킥보드 대여")
    }
    
    /// 킥보드 반납
    static func returnKickboard(id: UUID, latitude: Double, longitude: Double, battery: Int, imagePath: String) async throws {
        let userId = try getCurrentUserId()
        
        let user = try getUserData(id: userId)
        let kickboard = try getKickboardData(id: id)
        
        /// 탑승 정보 CoreData에서 호출
        guard let latestRide = try getRideListData(userId: userId).last else {
            throw KickboardPersistenceError.rideNotFound
        }
        
        let now = Date()
        
        // 해당 킥보드 정보 수정
        kickboard.latitude = latitude
        kickboard.longitude = longitude
        kickboard.battery = Int16(battery)
        kickboard.status = setStatus(battery: battery)
        
        // 해당 킥보드의 가장 최신 탑승 정보 수정
        latestRide.end_latitude = latitude
        latestRide.end_longitude = longitude
        latestRide.end_time = now
        latestRide.price = calculateCharge(from: latestRide.start_time ?? now, to: now)
        latestRide.image_path = imagePath
        latestRide.battery = kickboard.battery
        
        latestRide.kickboard = kickboard
        latestRide.user = user

        try await saveContext("킥보드 반납")
    }
    
    /// 킥보드 신고
    static func declaredKickboard(id: UUID) async throws {
        let kickboard = try getKickboardData(id: id)
        
        kickboard.status = "DECLARED"
        try await saveContext("킥보드 신고")
    }
    
    /// 킥보드 삭제
    static func deleteKickboard(id: UUID) async throws {
        let kickboard = try getKickboardData(id: id)
        context.delete(kickboard)
        try await saveContext("킥보드 삭제")
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
            print("킥보드 리스트가 존재하지 않음")
            throw KickboardPersistenceError.fetchKickboardFaild
        }
    }
    
    /// CoreData Persistence 저장소에서 탑승 정보 Entity 추출
    @discardableResult
    private static func getRideData(id: UUID) throws -> KickboardRideEntity {
        let request = NSFetchRequest<KickboardRideEntity>(entityName: KickboardRideEntity.className)
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
    private static func getRideListData(userId: UUID) throws -> [KickboardRideEntity] {
        let request = NSFetchRequest<KickboardRideEntity>(entityName: KickboardRideEntity.className)
        request.predicate = NSPredicate(format: "user_id == %@", userId as CVarArg)
        
        do {
            let rides = try context.fetch(request)
            return rides.sorted { ($0.start_time ?? .distantPast) < ($1.start_time ?? .distantPast) }
        } catch {
            print("탑승정보 리스트가 존재하지 않음")
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

// MARK: - Extension + KickboardPersistenceManager
/// DB저장 전 수행해야 하는 로직 추가
extension KickboardPersistenceManager {
    
    /// 시간 계산 추가요금 부과
    static private func calculateCharge(from start: Date, to end: Date) -> Int16 {
        let minutes = Calendar.current.dateComponents([.minute], from: start, to: end).minute ?? 0
        return Int16((minutes * 100) + 500)
    }
    
    /// 상태 태그 반환
    static private func setStatus(battery: Int) -> String {
        switch battery {
        case 0...10: return "LOW_BATTERY"
        default: return "ABLE"
        }
    }
    
    /// UserDefaults를 조회하는 메소드
    static func getCurrentUserId() throws -> UUID {
        guard let idString = UserDefaults.standard.string(forKey: "token"),
              let id = UUID(uuidString: idString) else {
            throw KickboardPersistenceError.tokenNotValid
        }
        return id
    }
}
