//
//  Kickboard.swift
//  WhatIsKickboardTests
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation
@testable import WhatIsKickboard

// MARK: - Kickboard Mock
extension Kickboard {
    func getMock() -> Self {
        return Kickboard(
            id: UUID(),
            latitude: 37.1236,
            longitude: 127.1236,
            battery: 50,
            status: "ABLE"
        )
    }
}
