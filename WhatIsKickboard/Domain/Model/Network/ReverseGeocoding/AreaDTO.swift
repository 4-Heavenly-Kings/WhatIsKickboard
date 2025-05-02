//
//  AreaDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

struct AreaDTO: Decodable {
    let name: String
}

extension AreaDTO {
    func toModel() -> AreaModel {
        AreaModel(name: name)
    }
}
