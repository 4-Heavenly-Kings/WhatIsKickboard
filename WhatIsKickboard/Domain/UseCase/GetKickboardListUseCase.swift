//
//  GetKickboardListUseCase.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/5/25.
//

import Foundation

import RxSwift

final class GetKickboardListUseCase: GetKickboardListUseCaseInterface {
    
    let repository: GetKickboardListRepository
    
    init(repository: GetKickboardListRepository) {
        self.repository = repository
    }
    
    func getKickboardList() -> Single<[Kickboard]> {
        return repository.getKickboardList()
    }
}
