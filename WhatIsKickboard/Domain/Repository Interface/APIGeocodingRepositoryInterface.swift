//
//  GeocodingAPIRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

import RxSwift

protocol APIGeocodingRepositoryInterface {
    /// API를 통한 장소 검색
    func fetchSearchResults(for query: String) -> Single<[LocationModel]>
    /// API를 통한 좌표 ➡️ 주소 검색
    func fetchCoordToAddress(coords: String) -> Single<[ReverseGeoResultModel]>
}
