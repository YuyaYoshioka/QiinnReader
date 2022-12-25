//
//  GetQiitaItemsRepository.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/18.
//

import Foundation
import Combine

protocol QiitaItemsRepository {
    func loadQiitaItems(page: Int) -> AnyPublisher<[QiitaItem], Error>
}


final class QiitaItemsRepositoryImpl: QiitaItemsRepository {
    func loadQiitaItems(page: Int) -> AnyPublisher<[QiitaItem], Error> {
        let urlStr = qiitaBaseURL + "/items?page=\(page)"
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
            .decode(type: [QiitaItem].self, decoder: decoder)
            .eraseToAnyPublisher()
        
        return result
    }
}
