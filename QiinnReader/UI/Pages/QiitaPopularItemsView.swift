//
//  QiitaPopularItemsView.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/28.
//

import SwiftUI

struct QiitaPopularItemsView: View {
    @ObservedObject var qiitaPopularItemsViewModel: QiitaPopularItemsViewModel
    @Binding var selectedTab: QiitaItemsView.SelectedTab
    
    var body: some View {
        ScrollView {
            LazyVStack {
                QiitaItemsView.TopTabView(selectedTab: $selectedTab)
                    .padding(.top)
                    .padding(.bottom)
                ForEach(qiitaPopularItemsViewModel.items, id: \.entry.id) { item in
                    QiitaPopularItemListCard(item: item)
                        .padding(.leading)
                        .padding(.trailing)
                    Divider()
                }
            }
        }
        .refreshable {
            qiitaPopularItemsViewModel.loadData()
        }
        .onAppear {
            if !qiitaPopularItemsViewModel.items.isEmpty { return }
            qiitaPopularItemsViewModel.loadData()
        }
    }
}

//struct QiitaPopularItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        QiitaPopularItemsView()
//    }
//}
