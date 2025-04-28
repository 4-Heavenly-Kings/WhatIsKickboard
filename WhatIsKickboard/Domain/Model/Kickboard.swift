//
//  Kickboard.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation

// MARK: - Kickboard
struct Kickboard {
    let id: UUID
    var latitude: Double
    var longitude: Double
    var battery: Int
    var status: String       // "ABLE", "DECLARED", "LOW_BATTERY"
}
