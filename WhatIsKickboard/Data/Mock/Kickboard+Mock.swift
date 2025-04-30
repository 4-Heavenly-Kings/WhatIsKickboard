//
//  Kickboard.swift
//  WhatIsKickboardTests
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation

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
    
    func getMockList() -> [Self] {
        return [
            Kickboard(id: UUID(), latitude: 37.5665, longitude: 126.9780, battery: 82, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5790, longitude: 126.9780, battery: 65, status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5545, longitude: 126.9780, battery: 50, status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5665, longitude: 126.9910, battery: 30, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5665, longitude: 126.9650, battery: 45, status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5800, longitude: 126.9900, battery: 20, status: "IMPOSSIBILITY"),
            Kickboard(id: UUID(), latitude: 37.5530, longitude: 126.9900, battery: 75, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5800, longitude: 126.9660, battery: 55, status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5530, longitude: 126.9660, battery: 90, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5750, longitude: 126.9850, battery: 35, status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5580, longitude: 126.9700, battery: 60, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5740, longitude: 126.9660, battery: 40, status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5580, longitude: 126.9860, battery: 25, status: "IMPOSSIBILITY"),
            Kickboard(id: UUID(), latitude: 37.5560, longitude: 126.9820, battery: 85, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5740, longitude: 126.9900, battery: 15, status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5650, longitude: 126.9700, battery: 70, status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5540, longitude: 126.9780, battery: 95, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5650, longitude: 126.9860, battery: 10, status: "IMPOSSIBILITY"),
            Kickboard(id: UUID(), latitude: 37.5665, longitude: 126.9900, battery: 50, status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5665, longitude: 126.9660, battery: 65, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5620, longitude: 126.9720, battery: 78, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5690, longitude: 126.9800, battery: 55, status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5580, longitude: 126.9680, battery: 45, status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5720, longitude: 126.9900, battery: 35, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5550, longitude: 126.9850, battery: 60, status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5890, longitude: 126.9750, battery: 25, status: "IMPOSSIBILITY"),
            Kickboard(id: UUID(), latitude: 37.5470, longitude: 126.9760, battery: 88, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5660, longitude: 126.9610, battery: 52, status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5760, longitude: 126.9680, battery: 30, status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5590, longitude: 126.9820, battery: 90, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.2060, longitude: 127.0680, battery: 80, status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.2061, longitude: 127.0681, battery: 50, status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.2062, longitude: 127.0682, battery: 10, status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.2063, longitude: 127.0683, battery: 60, status: "IMPOSSIBILITY"),
            Kickboard(id: UUID(), latitude: 37.2064, longitude: 127.0684, battery: 40, status: "ABLE")
        ]
    }
}
