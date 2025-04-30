//
//  AddressDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

struct AddressDTO: Decodable {
    let roadAddress, jibunAddress, englishAddress: String
    let addressElements: [AddressElementDTO]
    let x, y: String
    let distance: Double
}

extension AddressDTO {
    func toModel() -> AddressModel {
        return AddressModel(roadAddress: roadAddress,
                            jibunAddress: jibunAddress,
                            englishAddress: englishAddress,
                            addressElements: addressElements.map { $0.toModel() },
                            x: x,
                            y: y,
                            distance: distance)
    }
}
