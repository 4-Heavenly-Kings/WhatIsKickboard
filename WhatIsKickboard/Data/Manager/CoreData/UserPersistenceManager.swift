//
//  Empty1.swift
//  WhatIsKickboard
//
//  Created by 백래훈 on 4/25/25.
//

import Foundation
import CoreData
import RxSwift

// MARK: - UserPersistenceManager
/// 유저정보 CRUD Manager
final class UserPersistenceManager: BaseCoreDataManager {
    
    /// 로그인
    func login(_ email: String, _ password: String) -> Single<User> {
        return Single.create { single in
            do {
                let user = try self.getUserData(email: email)
                
                guard user.password == password else {
                    throw UserPersistenceError.passwordIsWorng
                }
                
                print("로그인 성공")
                UserDefaults.standard.set(user.id?.uuidString, forKey: "token")
                single(.success(user.toModel()))
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    /// 회원가입
    func createUser(_ email: String, _ password: String) -> Single<User> {
        return Single.create { single in
            do {
                do {
                    try self.getUserData(email: email)
                    throw UserPersistenceError.alreayUser
                } catch let error as UserPersistenceError {
                    if error == .userNotFound {
                        let user = UserEntity(context: self.context)
                        user.id = UUID()
                        user.email = email
                        user.password = password
                        user.role = "GUEST"
                        
                        UserDefaults.standard.set(user.id?.uuidString, forKey: "token")
                        try self.context.save()
                        single(.success(user.toModel()))
                    } else {
                        throw error
                    }
                }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    
    /// 유저정보 조회
    func getUser() -> Single<User> {
        return Single.create { single in
            do {
                guard let id = UserDefaults.standard.object(forKey: "token") as? String else {
                    throw UserPersistenceError.tokenNotValid
                }
                print("유저정보 조회 성공")
                let user = try self.getUserData(id: UUID(uuidString: id))
                single(.success(user.toModel()))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    /// 유저정보 변경
    func patchUser(_ user: User) -> Single<User> {
        return Single.create { single in
            do {
                let userData = try self.getUserData(id: user.id)
                
                userData.name = user.name
                userData.role = user.role
                userData.email = user.email
                userData.password = user.password
                
                try self.context.save()
                single(.success(userData.toModel()))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    /// 로그아웃
    func logout() {
        print("로그아웃")
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
    /// 회원탈퇴
    func deleteUser(password: String) async throws {
        guard let id = UserDefaults.standard.object(forKey: "token") as? String else {
            throw UserPersistenceError.tokenNotValid
        }
        let user = try getUserData(id: UUID(uuidString: id))
        guard password == user.password else {
            throw UserPersistenceError.passwordIsWorng
        }
        context.delete(user)
        
        try await saveContext("회원탈퇴")
        UserDefaults.standard.removeObject(forKey: "token")
    }
}

// MARK: Extension + UserPersistenceManager
/// 데이터 및 데이터 리스트 Entity 추출
extension UserPersistenceManager {
    
    /// CoreData Persistence 저장소에서 유저 Entity 추출
    @discardableResult
    private func getUserData(id: UUID? = nil, email: String? = nil) throws -> UserEntity {
        let request = NSFetchRequest<UserEntity>(entityName: UserEntity.className)
        
        if let id {
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        } else if let email {
            request.predicate = NSPredicate(format: "email == %@", email as String)
        }
        
        request.fetchLimit = 1
        guard let user = try context.fetch(request).first else {
            print("해당 유저가 존재하지 않음")
            throw UserPersistenceError.userNotFound
        }
        return user
    }
    
}
