//
//  DeclareKickboardUseCaseInterface.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/5/25.
//

import Foundation

protocol DeclareKickboardUseCaseInterface {
    func declareKickboard(id: UUID) async throws
}
