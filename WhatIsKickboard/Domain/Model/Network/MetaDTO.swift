//
//  MetaDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

struct MetaDTO: Decodable {
    let totalCount, page, count: Int
}

extension MetaDTO {
    func toModel() -> MetaModel {
        return MetaModel(totalCount: totalCount, page: page, count: count)
    }
}
