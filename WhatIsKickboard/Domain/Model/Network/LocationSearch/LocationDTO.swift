//
//  LocationDTO.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation
import CoreLocation

/// 네이버 지역 검색 API 응답 요소 중 개별 검색 결과 DTO
struct LocationDTO: Decodable {
    enum CodingKeys: CodingKey {
        case title
        case address
        case roadAddress
        case mapx
        case mapy
    }
    
    let title: String
    let address: String
    let roadAddress, mapx, mapy: String
    
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
        let coordinates = convertMapCoordinates(mapx: mapx, mapy: mapy)
        return LocationModel(title: title,
                      address: address,
                      roadAddress: roadAddress,
                      coordinates: coordinates ?? CLLocationCoordinate2D())
    }
    
    /// 개별 검색 결과 DTO의 mapx, mapy를 CLLocationCoordinate2D 형태로 반환하는 메서드
    func convertMapCoordinates(mapx: String, mapy: String) -> CLLocationCoordinate2D? {
        guard mapx.count >= 4, mapy.count >= 3 else { return nil }
        
        let indexX = mapx.index(mapx.startIndex, offsetBy: 3)
        let formattedMapX = mapx[..<indexX] + "." + mapx[indexX...]
        
        let indexY = mapy.index(mapy.startIndex, offsetBy: 2)
        let formattedMapY = mapy[..<indexY] + "." + mapy[indexY...]
        
        if let lon = Double(formattedMapX), let lat = Double(formattedMapY) {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            return nil
        }
    }
}
