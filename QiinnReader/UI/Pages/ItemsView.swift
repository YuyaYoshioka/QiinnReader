//
//  ItemsView.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/18.
//

import SwiftUI

struct ItemsView: View {
    @ObservedObject private var qiitaItemsViewModel: QiitaItemsViewModel
    
    init(qiitaItemsViewModel: QiitaItemsViewModel) {
        self.qiitaItemsViewModel = qiitaItemsViewModel
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack {
                        ForEach(qiitaItemsViewModel.qiitaItems) { qiitaItem in
                            QiitaItemListCard(item: qiitaItem)
                                .padding(.leading)
                                .padding(.trailing)
                            Divider()
                        }
                    }
                    .background(GeometryReader { proxy -> Color in
                        if -proxy.frame(in: .global).origin.y + geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom == proxy.size.height {
                            qiitaItemsViewModel.loadQiitaItems(refresh: false)
                        }
                        return Color.clear
                    })
                }
                .refreshable {
                    qiitaItemsViewModel.loadQiitaItems(refresh: true)
                }
                .navigationTitle("記事一覧")
            }
        }
        .onAppear {
            if !qiitaItemsViewModel.qiitaItems.isEmpty { return }
            qiitaItemsViewModel.loadQiitaItems(refresh: false)
        }
    }
}

//struct ItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemsView(qiitaItemsViewModel: QiitaItemsViewModel())
//    }
//}
