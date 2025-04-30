//
//  SearchResultDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

/// 네이버 지역 검색 API 응답 DTO
struct SearchResultDTO: Decodable {
    let locationDTOList: [LocationDTO]
    
    enum CodingKeys: String, CodingKey {
        case locationDTOList = "items"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locationDTOList = try container.decode([LocationDTO].self, forKey: .locationDTOList)
    }
}

