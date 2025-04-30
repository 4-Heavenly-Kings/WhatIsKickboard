//
//  LocationModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation
import CoreLocation

/// 네이버 지역 검색 API 응답 요소 중 개별 검색 결과 Model
struct LocationModel {
    /// 업체, 기관의 이름
    let title: String
    /// 업체, 기관명의 지번 주소
    let address: String
    /// 업체, 기관명의 도로명 주소
    let roadAddress: String
    /// Core Location 좌표
    let coordinate: CLLocationCoordinate2D
}
