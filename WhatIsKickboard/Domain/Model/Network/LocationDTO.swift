//
//  LocationDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

struct LocationDTO: Decodable {
    let title: String
    let address: String
    let roadAddress, mapx, mapy: String
    
    enum CodingKeys: CodingKey {
        case title
        case address
        case roadAddress
        case mapx
        case mapy
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawTitle = try container.decode(String.self, forKey: .title)
        let titleResult = rawTitle.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
        self.title = titleResult
        self.address = try container.decode(String.self, forKey: .address)
        self.roadAddress = try container.decode(String.self, forKey: .roadAddress)
        self.mapx = try container.decode(String.self, forKey: .mapx)
        self.mapy = try container.decode(String.self, forKey: .mapy)
    }
}

extension LocationDTO {
    func toModel() -> LocationModel {
        LocationModel(title: title,
                      address: address,
                      roadAddress: roadAddress,
                      mapx: Int(mapx) ?? 0,
                      mapy: Int(mapy) ?? 0)
    }
}
