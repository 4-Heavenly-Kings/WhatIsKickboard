//
//  ReverseGeocodingAPIRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

import RxSwift

protocol ReverseGeocodingAPIRepository {
    /// API를 통한 좌표 ➡️ 주소 검색
    func fetchCoordToAddress(coords: String) -> Single<[ReverseGeoResultModel]>
}
