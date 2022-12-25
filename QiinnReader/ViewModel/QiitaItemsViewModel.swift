//
//  QiitaItemsViewModel.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/18.
//

import Foundation
import Combine

final class QiitaItemsViewModel: ObservableObject {
    private var qiitaItemsRepository: QiitaItemsRepository
    private var cancellable: AnyCancellable?
    private var page = 1

    @Published var qiitaItems: [QiitaItem] = []
    
    init(qiitaItemsRepository: QiitaItemsRepository = QiitaItemsRepositoryImpl()) {
        self.qiitaItemsRepository = qiitaItemsRepository
    }
    
    func loadQiitaItems(refresh: Bool) {
        if refresh {
            page = 1
        }
        if page > 100 {
            return
        }
        IndicatorControl.shared.showLoading()
        cancellable = qiitaItemsRepository.loadQiitaItems(page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    if let apiError = error as? APIError {
                        print("error: \(apiError.description)")
                    }
                case .finished:
                    print("loadQiitaItems finished")
                    IndicatorControl.shared.hideLoading()
                    self.page += 1
                }
            },
              receiveValue: { qiitaItems in
                if refresh {
                    self.qiitaItems = qiitaItems
                } else {
                    self.qiitaItems += qiitaItems
                }
            }
        )
    }
}
