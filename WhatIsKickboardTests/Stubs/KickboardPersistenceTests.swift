//
//  KeyboardPersistenceTests.swift
//  WhatIsKickboardTests
//
//  Created by 유영웅 on 4/28/25.
//

import Testing
@testable import WhatIsKickboard
import Foundation

struct KickboardPersistenceTests {
    
    /// 킥보드 조회 테스트
    @Test func getKickboard() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String, let uuid = UUID(uuidString: id) else {
            throw KickboardPersistenceError.kickboardNotFound
        }
        do {
            let kickboard = try KickboardPersistenceManager.getKickboard(id: uuid)
            print(kickboard)
            #expect(kickboard.longitude == kickboard.getMock().longitude)
        } catch {
            #expect(Bool(false))
        }
    }
    
    /// 킥보드 리스트 조회 테스트
    @Test func getKickboardList() async throws {
        do {
            let kickboards = try KickboardPersistenceManager.getKickboardList()
            print(kickboards)
            #expect(!kickboards.isEmpty)
        } catch {
            #expect(Bool(false))
        }
    }
    
    /// 킥보드 등록 테스트
    @Test func testCreateKickboard() async throws {
        let id = try await KickboardPersistenceManager.createKickboard(latitude: 37.1234, longitude: 127.1234, battery: 80)
        UserDefaults.standard.set(id.uuidString, forKey: "kickboard_id")
        let kickboard = try KickboardPersistenceManager.getKickboard(id: id)
        
        #expect(kickboard.battery == kickboard.getMock().battery)
    }
    
    /// 킥보드 대여 테스트
    @Test func testRentKickboard() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String, let uuid = UUID(uuidString: id) else {
            throw KickboardPersistenceError.kickboardNotFound
        }
        let kickboard = try KickboardPersistenceManager.getKickboard(id: uuid)
        
        try await KickboardPersistenceManager.rentKickboard(id: kickboard.id, latitude: 37.1235, longitude: 127.1235)
        let updatedKickboard = try KickboardPersistenceManager.getKickboard(id: kickboard.id)
        print(updatedKickboard)
        #expect(updatedKickboard.status == "IMPOSSIBILITY")
    }
    
    /// 킥보드 반납 테스트
    @Test func testReturnKickboard() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String, let uuid = UUID(uuidString: id) else { return }
        try await KickboardPersistenceManager.returnKickboard(id: uuid, latitude: 37.1236, longitude: 127.1236, battery: 50, imagePath: "test/path")
        
        let returnedKickboard = try KickboardPersistenceManager.getKickboard(id: uuid)
        print(returnedKickboard)
        #expect(returnedKickboard.battery == 50)
        #expect(returnedKickboard.status == "ABLE" || returnedKickboard.status == "LOW_BATTERY")
    }
    
    /// 킥보드 신고 테스트
    @Test func testDeclaredKickboard() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String, let uuid = UUID(uuidString: id) else { return }
        try await KickboardPersistenceManager.declaredKickboard(id: uuid)
        
        let declaredKickboard = try KickboardPersistenceManager.getKickboard(id: uuid)
        print(declaredKickboard)
        #expect(declaredKickboard.status == "DECLARED")
    }
    
    /// 킥보드 삭제 테스트
    @Test func testDeleteKickboard() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String, let uuid = UUID(uuidString: id) else { return }
        try await KickboardPersistenceManager.deleteKickboard(id: uuid)
        
        let kickboards = try KickboardPersistenceManager.getKickboardList()
        #expect(!kickboards.contains { $0.id == uuid })
    }
}
