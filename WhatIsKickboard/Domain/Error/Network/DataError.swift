//
//  DataError.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

enum DataError: String, Error {
    case fileNotFound = "JSON 파일 없음"
    case parsingFailed = "JSON 파싱 에러"
}
