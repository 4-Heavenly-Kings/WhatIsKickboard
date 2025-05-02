//
//  LandDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

struct LandDTO: Decodable {
    let type, number1, number2: String
    let addition0: AdditionDTO
    let name: String?
}

extension LandDTO {
    func toModel() -> LandModel {
        LandModel(type: type,
                  number1: number1,
                  number2: number2,
                  addition0: addition0.toModel(),
                  name: name)
    }
}
