//
//  QiitaItemViewModel.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/28.
//

import Foundation
import Combine

final class QiitaItemViewModel: ObservableObject {
    private var qiitaItemRepository: QiitaItemRepository
    private var cancellable: AnyCancellable?
    
    @Published var qiitaItem: QiitaItem?
    
    init(qiitaItemRepository: QiitaItemRepository = QiitaItemRepositoryImpl(), qiitaItem: QiitaItem? = nil) {
        self.qiitaItemRepository = qiitaItemRepository
        self.qiitaItem = qiitaItem
    }
    
    func loadData(qiitaItemID: String) {
        IndicatorControl.shared.showLoading()
        cancellable = qiitaItemRepository.loadData(itemID: qiitaItemID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                IndicatorControl.shared.hideLoading()
                
                switch completion {
                case .failure(let error):
                    if let apiError = error as? APIError {
                        print("error: \(apiError.description)")
                    }
                case .finished:
                    print("QiitaItemViewModel.loadData finished")
                }
            },
              receiveValue: { qiitaItem in
                self.qiitaItem = qiitaItem
            }
        )
    }
}
