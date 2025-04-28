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
    @discardableResult
    static func login(_ email: String, _ password: String) throws -> User {
        let user = try getUserData(email: email, context: context)
        
        print("로그인 성공")
        UserDefaults.standard.set(user.id?.uuidString, forKey: "token")
        return user.toModel()
    }
    
    /// 회원가입
    @discardableResult
    static func createUser(_ email: String, _ password: String) async throws -> User {
        do {
            try getUserData(email: email, context: context)
            throw UserPersistenceError.alreayUser
        } catch let error as UserPersistenceError {
            if error == .userNotFound {
                
                let user = UserEntity(context: context)
                user.id = UUID()
                user.email = email
                user.password = password
                user.role = "GUEST"
                
                UserDefaults.standard.set(user.id?.uuidString, forKey: "token")
                try await saveContext(context, "회원가입")
                return user.toModel()
            } else {
                throw error
            }
        }
    }
    
    
    /// 유저정보 조희
    @discardableResult
    static func getUser() throws -> User {
        guard let id = UserDefaults.standard.object(forKey: "token") as? String else {
            throw UserPersistenceError.tokenNotValid
        }
        print("유저정보 조희 성공")
        let user = try getUserData(id: UUID(uuidString: id), context: context)
        return user.toModel()
    }
    
    /// 유저정보 변경
    @discardableResult
    static func patchUser(_ user: User) async throws -> User {
        let userData = try getUserData(id: user.id, context: context)
        
        userData.name = user.name
        userData.role = user.role
        userData.email = user.email
        userData.password = user.password
        
        try await saveContext(context, "유저정보 수정")
        return userData.toModel()
    }
    
    /// 로그아웃
    static func logout() {
        print("로그아웃")
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
    /// 회원탈퇴
    static func deleteUser(password: String) async throws {
        guard let id = UserDefaults.standard.object(forKey: "token") as? String else {
            throw UserPersistenceError.tokenNotValid
        }
        let user = try getUserData(id: UUID(uuidString: id), context: context)
        guard password == user.password else {
            throw UserPersistenceError.passwordIsWorng
        }
        context.delete(user)
        
        try await saveContext(context, "회원탈퇴")
        UserDefaults.standard.removeObject(forKey: "token")
    }
}
