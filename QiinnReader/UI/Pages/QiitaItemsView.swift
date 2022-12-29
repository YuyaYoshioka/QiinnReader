//
//  QiitaItemsView.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/30.
//

import SwiftUI

struct QiitaItemsView: View {
    @State private var selectedTab: SelectedTab = .trend

    var body: some View {
        NavigationView {
            switch selectedTab {
            case .trend:
                QiitaPopularItemsView(qiitaPopularItemsViewModel: QiitaPopularItemsViewModel(), selectedTab: $selectedTab)
                    .navigationTitle("Qiita記事一覧")
            case .recent:
                QiitaRecentItemsView(qiitaItemsViewModel: QiitaItemsViewModel(), selectedTab: $selectedTab)
                    .navigationTitle("Qiita記事一覧")
            }
        }
    }
    
    enum SelectedTab {
        case trend, recent
    }
}

struct QiitaItemsView_Previews: PreviewProvider {
    static var previews: some View {
        QiitaItemsView()
    }
}
