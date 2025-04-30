//
//  GeocodingModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

struct GeocodingModel {
    /// 검색 결과 상태 코드
    let status: String
    /// 검색 메타 데이터
    let meta: MetaModel
    /// 주소 검색 결과 목록
    let addresses: [AddressModel]
    /// 예외 발생 시 메시지
    let errorMessage: String
}
