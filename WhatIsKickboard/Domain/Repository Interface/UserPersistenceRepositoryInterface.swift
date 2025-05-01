//
//  UserPersistenceRepository.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 5/1/25.
//

import Foundation

import RxSwift

protocol UserPersistenceRepositoryInterface {
    /// 로그인
    static func login(_ email: String, _ password: String) -> Single<User>
    /// 회원가입
    static func createUser(_ email: String, _ password: String) -> Single<User>
    /// 유저정보 조회
    static func getUser() -> Single<User>
    /// 유저정보 변경
    static func patchUser(_ user: User) -> Single<User>
    /// 로그아웃
    static func logout()
    /// 회원탈퇴
    static func deleteUser(password: String) async throws
}
