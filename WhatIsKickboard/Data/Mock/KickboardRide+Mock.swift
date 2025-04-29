//
//  Ride.swift
//  WhatIsKickboardTests
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation

// MARK: - KickboardRide Mock
extension KickboardRide {
    static func getMock(kickboardId: UUID, userId: UUID) -> Self {
        return KickboardRide(
            id: UUID(),
            userId: userId,
            kickboardId: kickboardId,
            startTime: Date(),
            endTime: nil,
            startLatitude: 37.1235,
            startLongitude: 127.1235,
            endLatitude: 37.1236,
            endLongitude: 127.1236,
            battery: 50,
            price: 500,
            imagePath: "test/path"
        )
    }
}
