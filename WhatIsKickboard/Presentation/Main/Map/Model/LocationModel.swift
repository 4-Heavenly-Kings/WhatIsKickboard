//
//  LocationModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

struct LocationModel {
    /// 업체, 기관의 이름
    let title: String
    /// 업체, 기관명의 지번 주소
    let address: String
    /// 업체, 기관명의 도로명 주소
    let roadAddress: String
    /// 업체, 기관이 위치한 장소의 x 좌표(KATECH 좌표계 기준)
    let mapx: String
    /// 업체, 기관이 위치한 장소의 y 좌표(KATECH 좌표계 기준)
    let mapy: String
}
