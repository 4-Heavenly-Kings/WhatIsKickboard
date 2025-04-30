//
//  Geocoding.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

struct Geocoding: Codable {
    let total, start, display: Int
    let items: [Item]
}
