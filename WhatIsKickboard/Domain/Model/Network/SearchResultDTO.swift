//
//  SearchResultDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

struct SearchResultDTO: Decodable {
    let locations: [LocationDTO]
    
    enum CodingKeys: String, CodingKey {
        case locations = "items"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locations = try container.decode([LocationDTO].self, forKey: .locations)
    }
}

