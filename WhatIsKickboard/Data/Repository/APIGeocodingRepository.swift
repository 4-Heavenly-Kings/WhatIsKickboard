//
//  APIGeocodingRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

import RxSwift

final class APIGeocodingRepository: APIGeocodingRepositoryInterface {
    
    let manager = APIGeocodingManager()
    
    /// 네이버 지역 검색 API 호출 Repository
    func fetchSearchResults(for query: String) -> Single<[LocationModel]> {
        manager.fetchSearchResults(for: query)
    }
    
    /// 네이버 Reverse Geocoding API 호출 Repository
    func fetchCoordToAddress(coords: String) -> Single<[ReverseGeoResultModel]> {
        manager.fetchCoordToAddress(coords: coords)
    }
}
