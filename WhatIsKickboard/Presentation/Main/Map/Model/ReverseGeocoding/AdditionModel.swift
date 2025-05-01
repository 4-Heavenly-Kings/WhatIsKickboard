//
//  AdditionModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

/**
 추가 정보
 - name이 roadaddr인 경우에만 상세 값 표시
 - land.addition0: 건물 정보
 */
struct AdditionModel {
    /// 추가 정보 타입(building)
    let type: String
    /// 추가 정보 값(건물 이름)
    let value: String
}
