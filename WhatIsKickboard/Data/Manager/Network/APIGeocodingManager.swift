//
//  APIGeocodingManager.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 5/1/25.
//

import Foundation
import OSLog

import RxSwift


final class APIGeocodingManager {
    
    /// 네이버 지역 검색 API 호출 
    func fetchSearchResults(for query: String) -> Single<[LocationModel]> {
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "APIGeocodingRepository")
        
        return Single<[LocationModel]>.create { single in
            
            guard let url = NetworkEndpoint.url(.locationSearchURL, query: query, coords: "") else {
                let message = NetworkError.invalidURL.rawValue
                os_log(.error, log: log, "%@", message)
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            os_log(.debug, log: log, "%@", "\(url)")
            
            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            guard let searchID = Bundle.main.object(forInfoDictionaryKey: "SEARCH_ID") as? String,
                  let searchSecret = Bundle.main.object(forInfoDictionaryKey: "SEARCH_SECRET") as? String else {
                os_log(.error, log: log, "API KEY 없음")
                single(.failure(NetworkError.requestFailed))
                return Disposables.create()
            }
            urlRequest.addValue(searchID, forHTTPHeaderField: "X-Naver-Client-Id")
            urlRequest.addValue(searchSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

            let task = URLSession.shared.dataTask(with: urlRequest) { data, response,  error in
                let successRange: Range = (200..<300)
                
                guard let data, error == nil else {
                    single(.failure(NetworkError.noData))
                    return
                }
                
                if let response: HTTPURLResponse = response as? HTTPURLResponse {
                    os_log(.debug, log: log, "%d", response.statusCode)
                    
                    if successRange.contains(response.statusCode) {
                        os_log(.debug, log: log, "data: %@", "\(data)")
                        guard let locationSearchDTO = try? JSONDecoder().decode(LocationSearchDTO.self, from: data) else {
                            single(.failure(DataError.parsingFailed))
                            return
                        }
                        
                        os_log(.debug, log: log, "LocationSearchDTO: %@", "\(LocationSearchDTO.self)")
                        single(.success(locationSearchDTO.items.map { $0.toModel() }))
                    } else {
                        os_log(.error, "%@", NetworkError.requestFailed.rawValue)
                        single(.failure(NetworkError.requestFailed))
                    }
                }
            }
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
    
    /// 네이버 Reverse Geocoding API 호출
    func fetchCoordToAddress(coords: String) -> Single<[ReverseGeoResultModel]> {
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "APIReverseGeocodingRepository")
        
        return Single<[ReverseGeoResultModel]>.create { single in
            
            guard let url = NetworkEndpoint.url(.reverseGeocodingBaseURL, query: "", coords: coords) else {
                let message = NetworkError.invalidURL.rawValue
                os_log(.error, log: log, "%@", message)
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            guard let clientID = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String,
                  let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String else {
                os_log(.error, log: log, "API KEY 없음")
                single(.failure(NetworkError.requestFailed))
                return Disposables.create()
            }
            urlRequest.addValue(clientID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
            urlRequest.addValue(clientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
    
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response,  error in
                let successRange: Range = (200..<300)
                
                guard let data, error == nil else {
                    single(.failure(NetworkError.noData))
                    return
                }
                
                if let response: HTTPURLResponse = response as? HTTPURLResponse {
                    os_log(.debug, log: log, "%d", response.statusCode)
                    
                    if successRange.contains(response.statusCode) {
                        os_log(.debug, log: log, "data: %@", "\(data)")
                        guard let reverseGeocodingDTO = try? JSONDecoder().decode(ReverseGeocodingDTO.self, from: data) else {
                            single(.failure(DataError.parsingFailed))
                            return
                        }
                        
                        os_log(.debug, log: log, "reverseGeocodingDTO: %@", "\(reverseGeocodingDTO)")
                        single(.success(reverseGeocodingDTO.results.map { $0.toModel() }))
                    } else {
                        os_log(.error, "%@", NetworkError.requestFailed.rawValue)
                        single(.failure(NetworkError.requestFailed))
                    }
                }
            }
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}
