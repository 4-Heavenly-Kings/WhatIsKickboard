//
//  GeocodingDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

struct GeocodingDTO: Decodable {
    let status: String
    let meta: MetaDTO
    let addresses: [AddressDTO]
    let errorMessage: String
}

extension GeocodingDTO {
    func toModel() -> GeocodingModel {
        return GeocodingModel(status: status,
                              meta: meta.toModel(),
                              addresses: addresses.map { $0.toModel() },
                              errorMessage: errorMessage)
    }
}
