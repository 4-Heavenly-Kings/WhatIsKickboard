//
//  LandModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

/// 상세 주소 정보
struct LandModel {
    /// 지적 타입
    let type: String
    /// 도로 이름
    let number1: String
    /// 상세 번호
    let number2: String
    /// 건물 정보
    let addition0: AdditionModel
    /// 도로 이름(name이 roadaddr인 경우에만 상세 값 표시)
    let name: String?
}
