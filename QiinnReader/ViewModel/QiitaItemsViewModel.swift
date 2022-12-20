//
//  QiitaItemsViewModel.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/18.
//

import Foundation
import Combine

final class QiitaItemsViewModel: ObservableObject {
    @Published var qiitaItems: [QiitaItem] = []
    var qiitaItemsRepository: QiitaItemsRepository
    var cancellable: AnyCancellable?
    
    init(qiitaItemsRepository: QiitaItemsRepository = QiitaItemsRepositoryImpl()) {
        self.qiitaItemsRepository = qiitaItemsRepository
    }
    
    func loadQiitaItems() {
        IndicatorControl.shared.showLoading()
        cancellable = qiitaItemsRepository.loadQiitaItems()
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
                }
            },
              receiveValue: { qiitaItems in
                self.qiitaItems = qiitaItems
            }
        )
    }
}
