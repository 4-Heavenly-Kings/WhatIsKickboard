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
        return Kickboard(id: self.id!, latitude: self.latitude, longitude: self.longitude, battery: Int(self.battery), status: self.status ?? "")
    }
}
