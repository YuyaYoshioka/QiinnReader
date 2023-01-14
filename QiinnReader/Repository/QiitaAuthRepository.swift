//
//  QiitaAuthRepository.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2023/01/11.
//

import Foundation
import Combine
import ArkanaKeys

protocol QiitaAuthRepository {
    func postData(code: String) -> AnyPublisher<QiitaAccessToken, Error>
    func getAuthenticatedUser(accessToken: String) -> AnyPublisher<QiitaAuthenticatedUser, Error>
}


final class QiitaAuthRepositoryImpl: QiitaAuthRepository {
    func postData(code: String) -> AnyPublisher<QiitaAccessToken, Error> {
        var request =  URLRequest(url: URL(string: qiitaAPIBaseURL + "/access_tokens")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var params: [String:String] = [:]
        params["client_id"] = ArkanaKeys.Global().clientID
        params["client_secret"] = ArkanaKeys.Global().clientSecret
        params["code"] = code
        request.httpBody = try! JSONSerialization.data(withJSONObject: params)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpRes = response as? HTTPURLResponse else {
                    throw APIError(description: "http response not found")
                }
                if (200..<300).contains(httpRes.statusCode) ==  false {
                    throw APIError(description: "Bad Http Status Code")
                }
                return data
            }
            .decode(type: QiitaAccessToken.self, decoder: decoder)
            .eraseToAnyPublisher()
        
        return result
    }
    
    func getAuthenticatedUser(accessToken: String) -> AnyPublisher<QiitaAuthenticatedUser, Error> {
        var request = URLRequest(url: URL(string: qiitaAPIBaseURL + "/authenticated_user")!)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpRes = response as? HTTPURLResponse else {
                    throw APIError(description: "http response not found")
                }
                if (200..<300).contains(httpRes.statusCode) == false {
                    throw APIError(description: "Bad HTTP Status Code")
                }
                return data
            }
            .decode(type: QiitaAuthenticatedUser.self, decoder: decoder)
            .eraseToAnyPublisher()
        
        return result
    }
}
