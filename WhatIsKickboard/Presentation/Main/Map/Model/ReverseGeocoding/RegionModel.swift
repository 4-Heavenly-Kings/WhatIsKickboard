//
//  RegionModel.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation


/**
 주소 정보(행정 구역 단위 이름)
  - area1.name: 행정안전부에서 공시한 시/도 이름
  - area2.name: 행정안전부에서 공시한 시/군/구 이름
  - area3.name: 행정안전부에서 공시한 읍/면/동 이름
  - area4.name: 행정안전부에서 공시한 리 이름
 */
struct RegionModel {
    let area1: AreaModel
    let area2: AreaModel
    let area3: AreaModel
    let area4: AreaModel
}
