//
//  UserPersistenceError.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/27/25.
//

import Foundation

enum UserPersistenceError: String, Error {
    case userNotFound = "해당 유저가 존재하지 않음"
}
