//
//  UserPersistenceError.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/27/25.
//

import Foundation

enum UserPersistenceError: String, Error {
    case userNotFound = "해당 유저가 존재하지 않음"
    case loginFailed = "로그인 실패"
    case registerFailed = "회원가입 실패"
    case updateFailed = "유저정보 수정 실패"
    case deleteFailed = "회원탈퇴 실패"
    case logoutFailed = "로그아웃 실패"
}
