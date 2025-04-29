//
//  UserEntity.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation

// MARK: - User
struct User {
    let id: UUID
    var email: String
    var password: String
    var name: String?
    var role: String
    var rides: [KickboardRide]?
}
