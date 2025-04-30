//
//  FetchAPIGeocodingUseCaseInterface.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

import RxSwift

protocol FetchAPIGeocodingUseCaseInterface {
    // TODO: - 현위치 좌표 전달
    /// API를 통한 주소 검색
    func fetchSearchResults(for query: String, lat: Double?, lng: Double?) -> Single<GeocodingModel>
}
