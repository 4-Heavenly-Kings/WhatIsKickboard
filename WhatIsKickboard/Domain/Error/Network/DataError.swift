//
//  DataError.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation

/// 네이버 지역 검색 API 응답 파싱 중 발생할 수 있는 오류 메세지 모음
enum DataError: String, Error {
    case fileNotFound = "JSON 파일 없음"
    case parsingFailed = "JSON 파싱 에러"
}
