//
//  RegionDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

struct RegionDTO: Decodable {
    let area1, area2, area3, area4: AreaDTO
}

extension RegionDTO {
    func toModel() -> RegionModel {
        RegionModel(area1: area1.toModel(),
                    area2: area2.toModel(),
                    area3: area3.toModel(),
                    area4: area4.toModel())
    }
}
