//
//  DeclareKickboardUseCase.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/5/25.
//

import Foundation

final class DeclareKickboardUseCase: DeclareKickboardUseCaseInterface {
    
    let repository: DeclareKickboardRepository
    
    init(repository: DeclareKickboardRepository) {
        self.repository = repository
    }
    
    func declareKickboard(id: UUID) {
        repository.declareKickboard(id: id)
    }
}
