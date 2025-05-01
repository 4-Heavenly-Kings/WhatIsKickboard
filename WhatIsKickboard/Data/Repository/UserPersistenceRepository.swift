//
//  UserPersistenceRepository.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 5/1/25.
//

import Foundation

import RxSwift

final class UserPersistenceRepository: UserPersistenceRepositoryInterface {
    
    let manager = UserPersistenceManager()
    
    /// 로그인
    func login(_ email: String, _ password: String) -> RxSwift.Single<User> {
        manager.login(email, password)
    }
    
    /// 회원가입
    func createUser(_ email: String, _ password: String) -> RxSwift.Single<User> {
        manager.createUser(email, password)
    }
    
    /// 유저정보
    func getUser() -> RxSwift.Single<User> {
        manager.getUser()
    }
    
    /// 유저정보 수정
    func patchUser(_ user: User) -> RxSwift.Single<User> {
        manager.patchUser(user)
    }
    
    /// 로그아웃
    func logout() {
        manager.logout()
    }
    
    /// 회원 탈퇴
    func deleteUser(password: String) async throws {
        try await manager.deleteUser(password: password)
    }
    
}
