//
//  FetchAPIGeocodingUseCase.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

import RxSwift

final class FetchAPIGeocodingUseCase: FetchAPIGeocodingUseCaseInterface {
    
    // TODO: 의존성 주입할 때 주석 해제
//    private let repository: APIGeocodingRepository
//    
//    init(repository: APIGeocodingRepository) {
//        self.repository = repository
//    }
    
    private let repository = APIGeocodingRepository()
    
    func fetchSearchResults(for query: String) -> Single<GeocodingModel> {
        return repository.fetchSearchResults(for: query)
    }
}
