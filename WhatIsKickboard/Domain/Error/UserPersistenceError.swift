//
//  UserPersistenceError.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/27/25.
//

import Foundation

enum UserPersistenceError: String, Error {
    case userNotFound = "해당 유저가 존재하지 않습니다."
    case tokenNotValid = "토큰이 유효하지 않습니다."
    case alreayUser = "이미 회원이 존재합니다."
    case passwordIsWorng = "비밀번호가 일치하지 않습니다."
    case emailTextFieldIsEmpty = "이메일을 입력하지 않았습니다."
    case passwordTextFieldIsEmpty = "비밀번호를 입력하지 않았습니다."
    case fieldIsEmpty = "입력하지 않은 필드가 있습니다."
}
