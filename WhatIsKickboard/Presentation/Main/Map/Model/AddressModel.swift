//
//  AddressModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

struct AddressModel {
    /// 도로명 주소
    let roadAddress: String
    /// 지번 주소
    let jibunAddress: String
    /// 영어 주소
    let englishAddress: String
    /// 주소를 이루는 요소들
    let addressElements: [AddressElementModel]
    /// x 좌표(경도)
    let x: String
    /// y 좌표(위도)
    let y: String
    /// 검색 중심 좌표로부터의 거리(단위: 미터)
    let distance: Double
}
