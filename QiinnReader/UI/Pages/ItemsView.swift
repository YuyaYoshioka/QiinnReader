//
//  ItemsView.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/18.
//

import SwiftUI

struct ItemsView: View {
    @ObservedObject var qiitaItemsViewModel: QiitaItemsViewModel
    
    init(qiitaItemsViewModel: QiitaItemsViewModel) {
        self.qiitaItemsViewModel = qiitaItemsViewModel
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 239/255, green: 239/255, blue: 239/255)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        ForEach(qiitaItemsViewModel.qiitaItems) { qiitaItem in
                            QiitaItemListCard(item: qiitaItem)
                                .padding(.leading)
                                .padding(.trailing)
                        }
                    }
                }
            }
            .navigationTitle("記事一覧")
        }
        .onAppear {
            if !qiitaItemsViewModel.qiitaItems.isEmpty { return }
            qiitaItemsViewModel.loadQiitaItems()
        }
    }
}

//struct ItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemsView()
//    }
//}
