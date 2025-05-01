//
//  AddtionDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

struct AdditionDTO: Decodable {
    let type, value: String
}

extension AdditionDTO {
    func toModel() -> AdditionModel {
        AdditionModel(type: type, value: value)
    }
}
