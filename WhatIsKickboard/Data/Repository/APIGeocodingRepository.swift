//
//  APIGeocodingRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation
import OSLog

import RxSwift

/// 네이버 지역 검색 API 호출 Repository
final class APIGeocodingRepository: GeocodingAPIRepository {
    
    let manager = APIGeocodingManager()
    
    func fetchSearchResults(for query: String) -> Single<[LocationModel]> {
        manager.fetchSearchResults(for: query)
    }
}
