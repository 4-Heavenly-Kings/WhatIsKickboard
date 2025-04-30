//
//  AddressElementDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

struct AddressElementDTO: Decodable {
    let types: [String]
    let longName, shortName, code: String
}

extension AddressElementDTO {
    func toModel() -> AddressElementModel {
        return AddressElementModel(types: types,
                            longName: longName,
                            shortName: shortName,
                            code: code)
    }
}
