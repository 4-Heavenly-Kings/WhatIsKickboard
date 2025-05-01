//
//  LocationSearchDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

/// 네이버 지역 검색 API 응답 DTO
struct LocationSearchDTO: Decodable {
    let items: [LocationDTO]
}
