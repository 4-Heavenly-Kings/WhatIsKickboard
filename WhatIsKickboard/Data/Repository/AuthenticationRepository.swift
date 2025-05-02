//
//  UserPersistenceRepository.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 5/1/25.
//

import Foundation

import RxSwift

final class AuthenticationRepository: AuthenticationRepositoryInterface {
    
    /// 로그인
    func login(_ email: String, _ password: String) -> RxSwift.Single<User> {
        UserPersistenceManager.login(email, password)
    }
    
    /// 회원가입
    func createUser(_ email: String, _ password: String) -> RxSwift.Single<User> {
        UserPersistenceManager.createUser(email, password)
    }
    
    /// 유저정보
    func getUser() -> RxSwift.Single<User> {
        UserPersistenceManager.getUser()
    }
    
    /// 유저정보 수정
    func patchUser(_ user: User) -> RxSwift.Single<User> {
        UserPersistenceManager.patchUser(user)
    }
    
}
