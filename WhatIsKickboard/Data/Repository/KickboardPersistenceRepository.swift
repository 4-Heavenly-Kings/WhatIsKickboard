//
//  KickboardPersistenceRepository.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 5/1/25.
//

import Foundation
import RxSwift

final class KickboardPersistenceRepository: KickboardPersistenceRepositoryInterface {
    
    let manager = KickboardPersistenceManager()
    
    /// 킥보드 리스트 조회
    func getKickboardList() -> Single<[Kickboard]> {
        manager.getKickboardList()
    }

    /// 킥보드 조회
    func getKickboard(id: UUID) -> Single<Kickboard> {
        manager.getKickboard(id: id)
    }
    
    /// 킥보드 탑승 정보 조회
    func getKickboardRide(id: UUID) -> Single<KickboardRide> {
        manager.getKickboardRide(id: id)
    }
    
    /// 킥보드 탑승 정보 리스트List 조회
    func getKickboardRideList(userId: UUID) -> Single<[KickboardRide]> {
        manager.getKickboardRideList(userId: userId)
    }
    
    /// 킥보드 등록
    func createKickboard(latitude: Double, longitude: Double, battery: Int, address: String) async throws -> UUID {
        try await manager.createKickboard(latitude: latitude, longitude: longitude, battery: battery, address: address)
    }
    
    /// 킥보드 대여
    func rentKickboard(id: UUID, latitude: Double, longitude: Double, address: String) async throws {
        try await manager.rentKickboard(id: id, latitude: latitude, longitude: longitude, address: address)
    }
    
    /// 킥보드 반납
    func returnKickboard(id: UUID, latitude: Double, longitude: Double, battery: Int, imagePath: String, address: String) async throws {
        try await manager.rentKickboard(id: id, latitude: latitude, longitude: longitude, address: address)
    }
    
    /// 킥보드 신고
    func declaredKickboard(id: UUID) async throws {
        try await manager.declaredKickboard(id: id)
    }
    
    /// 킥보드 삭제
    func deleteKickboard(id: UUID) async throws {
        try await manager.deleteKickboard(id: id)
    }
}
