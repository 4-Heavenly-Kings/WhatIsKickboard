//
//  KickboardRide.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation

// MARK: - KickboardRide
struct KickboardRide {
    let id: UUID
    let userId: UUID
    let kickboardId: UUID
    let startTime: Date
    let endTime: Date?
    let startLatitude: Double
    let startLongitude: Double
    let endLatitude: Double?
    let endLongitude: Double?
    let battery: Int
    let price: Int?
    let imagePath: String?
}
