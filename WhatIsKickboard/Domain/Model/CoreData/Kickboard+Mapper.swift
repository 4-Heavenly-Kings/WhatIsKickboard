//
//  Kickboard+Mapper.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation

// MARK: Kickboard + Mapper
extension KickboardEntity {
    func toModel() -> Kickboard {
        let rides = (self.rides as? Set<KickboardRideEntity>)?.map { $0.toModel() } ?? []
        return Kickboard(
            id: self.id ?? UUID(),
            latitude: self.latitude,
            longitude: self.longitude,
            battery: Int(self.battery),
            address: self.address ?? "",
            status: self.status ?? "",
            rides: rides
        )
    }
}
