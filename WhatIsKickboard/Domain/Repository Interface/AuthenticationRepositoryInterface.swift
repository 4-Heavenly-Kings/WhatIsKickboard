//
//  UserPersistenceRepository.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 5/1/25.
//

import Foundation

import RxSwift

protocol AuthenticationRepositoryInterface {
    /// 로그인
    func login(_ email: String, _ password: String) -> Single<User>
    /// 회원가입
    func createUser(_ email: String, _ password: String) -> Single<User>
    /// 유저정보 조회
    func getUser() -> Single<User>
    /// 유저정보 변경
    func patchUser(_ user: User) -> Single<User>
}
