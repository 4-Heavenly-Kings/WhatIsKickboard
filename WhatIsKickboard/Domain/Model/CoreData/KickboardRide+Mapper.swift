//
//  KickboardRide+Mapper.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 4/28/25.
//

import Foundation

// MARK: - KickboardRide + Mapper
extension KickboardRideEntity {
    func toModel() -> KickboardRide {
        return KickboardRide(
            id: self.id ?? UUID(),
            userId: self.user_id ?? UUID(),
            kickboardId: self.kickboard_id ?? UUID(),
            startTime: self.start_time ?? Date(),
            endTime: self.end_time,
            startLatitude: self.start_latitude,
            startLongitude: self.start_longitude,
            endLatitude: self.end_latitude,
            endLongitude: self.end_longitude,
            battery: Int(self.battery),
            price: Int(self.price),
            imagePath: self.image_path,
            address: self.address ?? ""
        )
    }
}
