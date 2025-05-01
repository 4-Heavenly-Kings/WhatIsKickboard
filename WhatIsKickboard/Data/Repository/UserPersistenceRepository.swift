//
//  UserPersistenceRepository.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 5/1/25.
//

import Foundation

import RxSwift

final class UserPersistenceRepository: UserPersistenceRepositoryInterface {
    
    /// 로그인
    static func login(_ email: String, _ password: String) -> RxSwift.Single<User> {
        UserPersistenceManager.login(email, password)
    }
    
    /// 회원가입
    static func createUser(_ email: String, _ password: String) -> RxSwift.Single<User> {
        UserPersistenceManager.createUser(email, password)
    }
    
    /// 유저정보
    static func getUser() -> RxSwift.Single<User> {
        UserPersistenceManager.getUser()
    }
    
    /// 유저정보 수정
    static func patchUser(_ user: User) -> RxSwift.Single<User> {
        UserPersistenceManager.patchUser(user)
    }
    
    /// 로그아웃
    static func logout() {
        UserPersistenceManager.logout()
    }
    
    /// 회원 탈퇴
    static func deleteUser(password: String) async throws {
        try await UserPersistenceManager.deleteUser(password: password)
    }
    
}
