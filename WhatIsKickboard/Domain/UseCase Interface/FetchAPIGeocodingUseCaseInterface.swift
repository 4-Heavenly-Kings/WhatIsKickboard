//
//  FetchAPIGeocodingUseCaseInterface.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

import RxSwift

protocol FetchAPIGeocodingUseCaseInterface {
    /// API를 통한 지역 검색
    func fetchSearchResults(for query: String) -> Single<[LocationModel]>
}
