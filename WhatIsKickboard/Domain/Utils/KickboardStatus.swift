//
//  KickboardStatus.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/29/25.
//

import Foundation

/// 킥보드 상태
enum KickboardStatus: String {
    case able = "ABLE"
    case declared = "DECLARED"
    case lowBattery = "LOW_BATTERY"
    case impossibility = "IMPOSSIBILITY"
    
    var korean: String {
        switch self {
        case .able:
            return "사용 가능"
        case .declared:
            return "신고 접수"
        case .impossibility:
            return "사용 중"
        case .lowBattery:
            return "배터리 부족"
        }
    }
}
