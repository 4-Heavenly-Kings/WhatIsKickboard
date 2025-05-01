//
//  ReverseGeoResultModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

/// 응답 결과
struct ReverseGeoResultModel {
    /// 주소 정보
    let region: RegionModel
    /// 상세 주소 정보
    let land: LandModel?
}
