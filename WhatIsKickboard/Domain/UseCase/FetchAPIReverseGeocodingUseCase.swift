//
//  FetchAPIReverseGeocodingUseCase.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

import RxSwift

final class FetchAPIReverseGeocodingUseCase: FetchAPIReverseGeocodingUseCaseInterface {
    
    // TODO: 의존성 주입할 때 주석 해제
//    private let repository: APIReverseGeocodingRepository
//
//    init(repository: APIReverseGeocodingRepository) {
//        self.repository = repository
//    }
    
    private let repository = APIReverseGeocodingRepository()
    
    func fetchCoordToAddress(coords: String) -> Single<[ReverseGeoResultModel]>  {
        return repository.fetchCoordToAddress(coords: coords)
    }
}
