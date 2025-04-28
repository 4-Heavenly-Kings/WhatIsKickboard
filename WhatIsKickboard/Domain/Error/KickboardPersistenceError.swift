//
//  UserPersistenceError.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/27/25.
//

import Foundation

enum KickboardPersistenceError: String, Error {
    case kickboardNotFound = "해당 킥보드가 존재하지 않습니다."
    case fetchFaild = "킥보드 데이터 로딩 실패"
}
