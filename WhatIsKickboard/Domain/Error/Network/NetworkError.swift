//
//  NetworkError.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURLComponents = "유효하지 않은 URL Components"
    case invalidURL = "유효하지 않은 URL"
    case noData = "데이터 없음"
    case requestFailed = "요청 실패"
}
