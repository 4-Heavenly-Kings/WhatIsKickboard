//
//  UserUseCase.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 5/1/25.
//

import Foundation

import RxSwift

final class UserPersistenceUseCase: UserPersistenceUseCaseInterface {
    
    // TODO: 의존성 주입할 때 주석 해제
    //    private let repository: UserPersistenceRepository
    //
    //    init(repository: UserPersistenceRepository) {
    //        self.repository = repository
    //    }
    
    private let repository = UserPersistenceRepository()
    
    /// 로그인
    func login(_ email: String, _ password: String) -> Single<User> {
        repository.login(email, password)
    }
    
    /// 회원가입
    func createUser(_ email: String, _ password: String) -> RxSwift.Single<User> {
        repository.createUser(email, password)
    }
    
    /// 유저정보
    func getUser() -> RxSwift.Single<User> {
        repository.getUser()
    }
    
    /// 유저정보 수정
    func patchUser(_ user: User) -> RxSwift.Single<User> {
        repository.patchUser(user)
    }
    
    /// 로그아웃
    func logout() {
        repository.logout()
    }
    
    /// 회원 탈퇴
    func deleteUser(password: String) async throws {
        try await repository.deleteUser(password: password)
    }
}
