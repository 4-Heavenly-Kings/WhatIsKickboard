//
//  FetchAPIGeocodingUseCase.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

import RxSwift

final class FetchAPIGeocodingUseCase: FetchAPIGeocodingUseCaseInterface {
    
    private let repository: APIGeocodingRepository
    
    init(repository: APIGeocodingRepository) {
        self.repository = repository
    }
    
    func fetchSearchResults(for query: String) -> Single<[LocationModel]> {
        return repository.fetchSearchResults(for: query)
    }
    
    func fetchCoordToAddress(coords: String) -> Single<[ReverseGeoResultModel]>  {
        return repository.fetchCoordToAddress(coords: coords)
    }
}
