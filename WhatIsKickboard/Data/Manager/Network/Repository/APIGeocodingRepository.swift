//
//  APIGeocodingRepository.swift
//  WhatIsKickboard
//
//  Created by 서동환 on 4/30/25.
//

import Foundation
import OSLog

import RxSwift

final class APIGeocodingRepository: GeocodingAPIRepository {
    func fetchSearchResults(for query: String) -> Single<GeocodingModel> {
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "APIGeocodingRepository")
        
        return Single<GeocodingModel>.create { single in
            
            guard var urlComponents = URLComponents(string: "https://maps.apigw.ntruss.com/map-geocode/v2/geocode") else {
                let message = NetworkError.invalidURLComponents.rawValue
                os_log(.error, log: log, "%@", message)
                single(.failure(NetworkError.invalidURLComponents))
                return Disposables.create()
            }
            
            let queryItemArray = [
                URLQueryItem(name: "query", value: query)
            ]
            urlComponents.queryItems = queryItemArray
            
            guard let url = urlComponents.url else {
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
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

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
                        guard let geocodingDTO = try? JSONDecoder().decode(GeocodingDTO.self, from: data) else {
                            single(.failure(DataError.parsingFailed))
                            return
                        }
                        
                        os_log(.debug, log: log, "geocodingDTO: %@", "\(geocodingDTO)")
                        single(.success(geocodingDTO.toModel()))
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
