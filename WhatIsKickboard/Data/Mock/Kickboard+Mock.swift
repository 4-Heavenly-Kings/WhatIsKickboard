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
            address: "서울특별시 종로구 세종대로 175",
            status: "ABLE"
        )
    }
    
    func getMockList() -> [Self] {
        return [
            Kickboard(id: UUID(), latitude: 37.5665, longitude: 126.9780, battery: 82, address: "서울특별시 종로구 세종대로 175", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5790, longitude: 126.9780, battery: 65, address: "서울특별시 종로구 율곡로 99", status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5545, longitude: 126.9780, battery: 50, address: "서울특별시 중구 퇴계로 264", status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5665, longitude: 126.9910, battery: 30, address: "서울특별시 중구 을지로 170", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5665, longitude: 126.9650, battery: 45, address: "서울특별시 서대문구 통일로 121", status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5800, longitude: 126.9900, battery: 20, address: "서울특별시 종로구 동숭길 25", status: "IMPOSSIBILITY"),
            Kickboard(id: UUID(), latitude: 37.5530, longitude: 126.9900, battery: 75, address: "서울특별시 중구 명동길 73", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5800, longitude: 126.9660, battery: 55, address: "서울특별시 종로구 자하문로 12", status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5530, longitude: 126.9660, battery: 90, address: "서울특별시 용산구 한강대로 92", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5750, longitude: 126.9850, battery: 35, address: "서울특별시 종로구 종로 1길 42", status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5580, longitude: 126.9700, battery: 60, address: "서울특별시 중구 퇴계로 100", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5740, longitude: 126.9660, battery: 40, address: "서울특별시 서대문구 신촌로 145", status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5580, longitude: 126.9860, battery: 25, address: "서울특별시 중구 충무로 23", status: "IMPOSSIBILITY"),
            Kickboard(id: UUID(), latitude: 37.5560, longitude: 126.9820, battery: 85, address: "서울특별시 중구 장충단로 275", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5740, longitude: 126.9900, battery: 15, address: "서울특별시 종로구 이화장길 26", status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5650, longitude: 126.9700, battery: 70, address: "서울특별시 서대문구 경기대로 47", status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5540, longitude: 126.9780, battery: 95, address: "서울특별시 중구 소공로 63", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5650, longitude: 126.9860, battery: 10, address: "서울특별시 중구 을지로 65", status: "IMPOSSIBILITY"),
            Kickboard(id: UUID(), latitude: 37.5665, longitude: 126.9900, battery: 50, address: "서울특별시 중구 청계천로 112", status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5665, longitude: 126.9660, battery: 65, address: "서울특별시 서대문구 독립문로 10", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5620, longitude: 126.9720, battery: 78, address: "서울특별시 중구 필동로 30", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5690, longitude: 126.9800, battery: 55, address: "서울특별시 종로구 종로 104", status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5580, longitude: 126.9680, battery: 45, address: "서울특별시 용산구 청파로 74", status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5720, longitude: 126.9900, battery: 35, address: "서울특별시 종로구 성균관로 28", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5550, longitude: 126.9850, battery: 60, address: "서울특별시 중구 명동8길 27", status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5890, longitude: 126.9750, battery: 25, address: "서울특별시 성북구 삼선교로 92", status: "IMPOSSIBILITY"),
            Kickboard(id: UUID(), latitude: 37.5470, longitude: 126.9760, battery: 88, address: "서울특별시 용산구 녹사평대로 150", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.5660, longitude: 126.9610, battery: 52, address: "서울특별시 서대문구 통일로 251", status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.5760, longitude: 126.9680, battery: 30, address: "서울특별시 종로구 평창문화로 45", status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.5590, longitude: 126.9820, battery: 90, address: "서울특별시 중구 장충단로 20", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.2060, longitude: 127.0680, battery: 80, address: "경기도 수원시 영통구 대학4로 17", status: "ABLE"),
            Kickboard(id: UUID(), latitude: 37.2061, longitude: 127.0681, battery: 50, address: "경기도 수원시 영통구 이의동 123", status: "DECLARED"),
            Kickboard(id: UUID(), latitude: 37.2062, longitude: 127.0682, battery: 10, address: "경기도 수원시 영통구 매영로 345", status: "LOW_BATTERY"),
            Kickboard(id: UUID(), latitude: 37.2063, longitude: 127.0683, battery: 60, address: "경기도 수원시 장안구 정자천로 98", status: "IMPOSSIBILITY"),
            Kickboard(id: UUID(), latitude: 37.2064, longitude: 127.0684, battery: 40, address: "경기도 성남시 분당구 불정로 6", status: "ABLE")
        ]
    }
}
