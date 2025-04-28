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
    static func getKickboardList() -> [Kickboard] {
        return []
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
