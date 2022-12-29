//
//  QiitaItemRepository.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/28.
//

import Foundation
import Combine

protocol QiitaItemRepository {
    func loadData(itemID: String) -> AnyPublisher<QiitaItem, Error>
}

final class QiitaItemRepositoryImpl: QiitaItemRepository {
    func loadData(itemID: String) -> AnyPublisher<QiitaItem, Error> {
        let urlStr = qiitaAPIBaseURL + "/items/\(itemID)"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = URLSession.shared.dataTaskPublisher(for: URL(string: urlStr)!)
            .tryMap({ data, response -> Data in
                guard let httpRes = response as? HTTPURLResponse else {
                    throw APIError(description: "http response not found")
                }
                if (200..<300).contains(httpRes.statusCode) == false {
                    throw APIError(description: "Bad Http Status Code")
                }
                return data
            })
            .decode(type: QiitaItem.self, decoder: decoder)
            .eraseToAnyPublisher()
        
        return result
    }
}
