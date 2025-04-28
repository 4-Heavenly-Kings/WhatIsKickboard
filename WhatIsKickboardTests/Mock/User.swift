//
//  User.swift
//  WhatIsKickboardTests
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation
@testable import WhatIsKickboard

// MARK: - User Mock
extension User {
    func getMock() -> Self{
        User(id: UUID(), email: "test@example.com", password: "password123", role: "GUEST")
    }
}
