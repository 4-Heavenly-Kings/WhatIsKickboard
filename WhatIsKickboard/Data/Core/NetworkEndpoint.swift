//
//  NetworkEndpoint.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 5/1/25.
//

import Foundation

enum NetworkEndpoint: String {
    case locationSearchURL = "https://openapi.naver.com/v1/search/local.json"
    case reverseGeocodingBaseURL = "https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc"
    
    static func url(_ baseURL: Self, query: String, coords: String) -> URL? {
        guard var urlComponents = URLComponents(string: "\(baseURL.rawValue)") else {
            return nil
        }
        
        var queryItemArray = [URLQueryItem]()
        if baseURL == .locationSearchURL {
            queryItemArray.append(URLQueryItem(name: "query", value: query))
            queryItemArray.append(URLQueryItem(name: "display", value: "5"))
        } else if baseURL == .reverseGeocodingBaseURL {
            queryItemArray.append(URLQueryItem(name: "coords", value: coords))
            queryItemArray.append(URLQueryItem(name: "orders", value: "roadaddr"))
            queryItemArray.append(URLQueryItem(name: "output", value: "json"))
        }
        urlComponents.queryItems = queryItemArray
        
        return urlComponents.url
    }
}
