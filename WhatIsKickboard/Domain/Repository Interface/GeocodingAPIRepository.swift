//
//  GeocodingAPIRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

import RxSwift

protocol GeocodingAPIRepository {
    /// API를 통한 주소 검색
    func fetchSearchResults(for query: String) -> Single<GeocodingModel>
}
