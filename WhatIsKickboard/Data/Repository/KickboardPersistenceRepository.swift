//
//  KickboardPersistenceRepository.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 5/1/25.
//

import Foundation
import RxSwift

final class KickboardPersistenceRepository: KickboardPersistenceRepositoryInterface {
    /// 킥보드 리스트 조회
    static func getKickboardList() -> Single<[Kickboard]> {
        KickboardPersistenceManager.getKickboardList()
    }

    /// 킥보드 조회
    static func getKickboard(id: UUID) -> Single<Kickboard> {
        KickboardPersistenceManager.getKickboard(id: id)
    }
    
    /// 킥보드 탑승 정보 조회
    static func getKickboardRide(id: UUID) -> Single<KickboardRide> {
        KickboardPersistenceManager.getKickboardRide(id: id)
    }
    
    /// 킥보드 탑승 정보 리스트List 조회
    static func getKickboardRideList(userId: UUID) -> Single<[KickboardRide]> {
        KickboardPersistenceManager.getKickboardRideList(userId: userId)
    }
    
    /// 킥보드 등록
    @discardableResult
    static func createKickboard(latitude: Double, longitude: Double, battery: Int, address: String) async throws -> UUID {
        try await KickboardPersistenceManager.createKickboard(latitude: latitude, longitude: longitude, battery: battery, address: address)
    }
    
    /// 킥보드 대여
    static func rentKickboard(id: UUID, latitude: Double, longitude: Double, address: String) async throws {
        try await KickboardPersistenceManager.rentKickboard(id: id, latitude: latitude, longitude: longitude, address: address)
    }
    
    /// 킥보드 반납
    static func returnKickboard(id: UUID, latitude: Double, longitude: Double, battery: Int, imagePath: String, address: String) async throws {
        try await KickboardPersistenceManager.rentKickboard(id: id, latitude: latitude, longitude: longitude, address: address)
    }
    
    /// 킥보드 신고
    static func declaredKickboard(id: UUID) async throws {
        try await KickboardPersistenceManager.declaredKickboard(id: id)
    }
    
    /// 킥보드 삭제
    static func deleteKickboard(id: UUID) async throws {
        try await KickboardPersistenceManager.deleteKickboard(id: id)
    }
}
