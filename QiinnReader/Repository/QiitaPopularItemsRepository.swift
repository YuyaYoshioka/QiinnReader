//
//  QiitaPopularItemsRepository.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/26.
//

import Foundation
import Combine

protocol QiitaPopularItemsRepository {
    func loadData() -> AnyPublisher<Data, Error>
}

final class QiitaPopularItemsRepositoryImpl: QiitaPopularItemsRepository {
    func loadData() -> AnyPublisher<Data, Error> {
        let urlStr = qiitaBaseURL + "/popular-items/feed"
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
            .eraseToAnyPublisher()
        
        return result
    }
}
