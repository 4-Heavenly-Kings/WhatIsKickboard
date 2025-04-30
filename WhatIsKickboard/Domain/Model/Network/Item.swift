//
//  Item.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

struct Item: Codable {
    let title: String
    let address: String
    let roadAddress, mapx, mapy: String
}
