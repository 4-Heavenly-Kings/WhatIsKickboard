//
//  UserPersistenceError.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/27/25.
//

import Foundation

enum KickboardPersistenceError: String, Error {
    case userNotFound = "해당 유저가 존재하지 않습니다."
    case tokenNotValid = "토큰이 유효하지 않습니다."
    case kickboardNotFound = "해당 킥보드가 존재하지 않습니다."
    case rideNotFound = "해당 탑승정보가 존재하지 않습니다."
    case fetchKickboardFaild = "킥보드 데이터 로딩 실패."
    case fetchRideFaild = "탑승정보 데이터 로딩 실패."
}
