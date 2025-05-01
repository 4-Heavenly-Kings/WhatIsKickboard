//
//  GeocodingAPIRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

import RxSwift

protocol GeocodingAPIRepository {
    /// API를 통한 장소 검색
    func fetchSearchResults(for query: String) -> Single<[LocationModel]>
}
