//
//  KeyboardPersistenceTests.swift
//  WhatIsKickboardTests
//
//  Created by 유영웅 on 4/28/25.
//

import Testing
import RxSwift
@testable import WhatIsKickboard
import Foundation

struct KickboardPersistenceTests {
    
    var disposeBag = DisposeBag()
    
    /// 킥보드 조회 테스트
    @Test func testGetKickboard() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String, let uuid = UUID(uuidString: id) else {
            throw KickboardPersistenceError.kickboardNotFound
        }
        getKickboard(id: uuid) { kickboard in
            print(kickboard)
            #expect(kickboard.longitude == kickboard.getMock().longitude)
        }
    }
    
    /// 킥보드 리스트 조회 테스트
    @Test func testGetKickboardList() async throws {
        getKickboardList { kickboards in
            print(kickboards)
            #expect(!kickboards.isEmpty)
        }
    }
    
    /// 킥보드 탑승정보 조회 테스트
    @Test func testGetKickboardRide() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String,
                let uuid = UUID(uuidString: id),
                let userId = UserDefaults.standard.object(forKey: "token") as? String,
                let userUuid = UUID(uuidString: userId)
        else {
            throw KickboardPersistenceError.kickboardNotFound
        }
        getKickboardRide(id: uuid) { ride in
            print(ride)
            #expect(ride.endLatitude == KickboardRide.getMock(kickboardId: uuid, userId: userUuid).endLatitude)
        }
    }
    
    /// 킥보드 탑승정보 리스트 조회 테스트
    @Test func testGetKickboardRideList() async throws {
        guard let userId = UserDefaults.standard.object(forKey: "token") as? String,
              let userUuid = UUID(uuidString: userId)
        else {
            throw KickboardPersistenceError.kickboardNotFound
        }
        getKickboardRideList(userId: userUuid) { kickboards in
            print(kickboards)
            #expect(!kickboards.isEmpty)
        }
    }
    
    /// 킥보드 등록 테스트
    @Test func testCreateKickboard() async throws {
        let id = try await KickboardPersistenceManager.createKickboard(latitude: 37.1234, longitude: 127.1234, battery: 80, address: "서울특별시 종로구 세종대로 175")
        UserDefaults.standard.set(id.uuidString, forKey: "kickboard_id")
        
        getKickboard(id: id) { kickboard in
            print(kickboard)
            #expect(kickboard.battery == kickboard.getMock().battery)
        }
    }
    
    /// 킥보드 대여 테스트
    @Test func testRentKickboard() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String, let uuid = UUID(uuidString: id) else {
            throw KickboardPersistenceError.kickboardNotFound
        }
        
        getKickboard(id: uuid) { kickboard in
            Task{
                try await KickboardPersistenceManager.rentKickboard(id: kickboard.id, latitude: 37.1235, longitude: 127.1235, address: "서울특별시 강남구 강남대로 1234")
                getKickboard(id: kickboard.id) { kickboard in
                    print(kickboard)
                    #expect(kickboard.status == "IMPOSSIBILITY")
                }
            }
        }
    }
    
    /// 킥보드 반납 테스트
    @Test func testReturnKickboard() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String, let uuid = UUID(uuidString: id) else { return }
        try await KickboardPersistenceManager.returnKickboard(id: uuid, latitude: 37.1236, longitude: 127.1236, battery: 50, imagePath: "test/path", address: "서울특별시 강남구 강남대로 1234")
        
        getKickboardRide(id: uuid) { ride in
            print(ride)
        }
    }
    
    /// 킥보드 신고 테스트
    @Test func testDeclaredKickboard() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String, let uuid = UUID(uuidString: id) else { return }
        try await KickboardPersistenceManager.declaredKickboard(id: uuid)
        
        getKickboard(id: uuid) { kickboard in
            print(kickboard)
            #expect(kickboard.status == "DECLARED")
        }
    }
    
    /// 킥보드 삭제 테스트
    @Test func testDeleteKickboard() async throws {
        guard let id = UserDefaults.standard.object(forKey: "kickboard_id") as? String, let uuid = UUID(uuidString: id) else { return }
        try await KickboardPersistenceManager.deleteKickboard(id: uuid)
        
        getKickboardList { kickboards in
            #expect(!kickboards.contains { $0.id == uuid })
        }
    }
}

// MARK: - 테스트가 아닌 메서드
extension KickboardPersistenceTests {
    // 킥보드 반환 핸들링
    private func getKickboard(id: UUID, completion: @escaping (Kickboard) -> Void) {
        KickboardPersistenceManager.getKickboard(id: id)
            .subscribe(onSuccess: { kickboard in
                completion(kickboard)
            }, onFailure: { _ in
                #expect(Bool(false))
            })
            .disposed(by: disposeBag)
    }
    
    // 킥보드 리스트 반환 핸들링
    private func getKickboardList(completion: @escaping ([Kickboard]) -> Void) {
        KickboardPersistenceManager.getKickboardList()
            .subscribe(onSuccess: { kickboards in
                completion(kickboards)
            }, onFailure: { _ in
                #expect(Bool(false))
            })
            .disposed(by: disposeBag)
    }
    
    // 킥보드 탑승정보 반환 핸들링
    private func getKickboardRide(id: UUID, completion: @escaping (KickboardRide) -> Void) {
        KickboardPersistenceManager.getKickboardRide(id: id)
            .subscribe(onSuccess: { ride in
                completion(ride)
            }, onFailure: { _ in
                #expect(Bool(false))
            })
            .disposed(by: disposeBag)
    }
    
    // 킥보드 탑승정보 리스트 반환 핸들링
    private func getKickboardRideList(userId: UUID, completion: @escaping ([KickboardRide]) -> Void) {
        KickboardPersistenceManager.getKickboardRideList(userId: userId)
            .subscribe(onSuccess: { kickboards in
                completion(kickboards)
            }, onFailure: { _ in
                #expect(Bool(false))
            })
            .disposed(by: disposeBag)
    }
}
