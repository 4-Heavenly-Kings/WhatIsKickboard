//
//  Empty1.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import Foundation
import CoreData

// MARK: - UserPersistenceManager
/// 유저정보 CRUD Manager
final class UserPersistenceManager: BaseCoreDataManager {
    
    static let context = CoreDataStack.shared.context
    
    /// 로그인
    static func login(_ email: String, _ password: String) throws -> User {
        let user = try getUserData(email: email, context: context)
        
        print("로그인 성공")
        UserDefaults.standard.set(user.id!, forKey: "token")
        return user
    }
    
    /// 회원가입
    static func createUser(_ email: String, _ password: String) async throws -> User {
        let user = User(context: context)
        user.id = UUID()
        user.email = email
        user.password = password
        user.role = "GUEST"
        try await saveContext(context, "회원가입")
        return user
    }
    
    
    /// 유저정보 조희
    static func getUser() -> User {
        return User(context: context)
    }
    
    /// 유저정보 변경
    static func patchUser(_ user: User) -> User {
        return User(context: context)
    }
    
    /// 로그아웃
    static func logout() -> Bool {
        return Bool()
    }
    
    /// 회원탈퇴
    static func deleteUser() -> Bool{
        return Bool()
    }
}
