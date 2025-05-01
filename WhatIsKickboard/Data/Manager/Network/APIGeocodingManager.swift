//
//  APIGeocodingManager.swift
//  WhatIsKickboard
//
//  Created by 유영웅 on 5/1/25.
//

import Foundation
import OSLog

import RxSwift

/// 네이버 지역 검색 API 호출 Manager
final class APIGeocodingManager {
    func fetchSearchResults(for query: String) -> Single<[LocationModel]> {
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "APIGeocodingRepository")
        
        return Single<[LocationModel]>.create { single in
            
            guard var urlComponents = URLComponents(string: "https://openapi.naver.com/v1/search/local.json") else {
                let message = NetworkError.invalidURLComponents.rawValue
                os_log(.error, log: log, "%@", message)
                single(.failure(NetworkError.invalidURLComponents))
                return Disposables.create()
            }
            
            let queryItemArray = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "display", value: "5")
            ]
            urlComponents.queryItems = queryItemArray
            
            guard let url = urlComponents.url else {
                let message = NetworkError.invalidURL.rawValue
                os_log(.error, log: log, "%@", message)
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            os_log(.debug, log: log, "%@", "\(url)")
            
            var urlRequest: URLRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            guard let clientID = Bundle.main.object(forInfoDictionaryKey: "SEARCH_ID") as? String,
                  let clientSecret = Bundle.main.object(forInfoDictionaryKey: "SEARCH_SECRET") as? String else {
                os_log(.error, log: log, "API KEY 없음")
                single(.failure(NetworkError.requestFailed))
                return Disposables.create()
            }
            urlRequest.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
            urlRequest.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

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
                        guard let searchResultDTO = try? JSONDecoder().decode(SearchResultDTO.self, from: data) else {
                            single(.failure(DataError.parsingFailed))
                            return
                        }
                        
                        os_log(.debug, log: log, "searchResultDTO: %@", "\(searchResultDTO)")
                        single(.success(searchResultDTO.locationDTOList.map { $0.toModel() }))
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
