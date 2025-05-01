//
//  ReverseGeoResultDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

struct ReverseGeoResultDTO: Decodable {
    let region: RegionDTO
    let land: LandDTO?
}

extension ReverseGeoResultDTO {
    func toModel() -> ReverseGeoResultModel {
        ReverseGeoResultModel(region: region.toModel(), land: land?.toModel())
    }
}
