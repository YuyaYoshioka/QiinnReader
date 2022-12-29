//
//  QiitaItemsView+TopTabView.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/30.
//

import SwiftUI

extension QiitaItemsView {
    struct TopTabView: View {
        @Binding var selectedTab: SelectedTab

        var body: some View {
            HStack {
                Spacer()
                Label("トレンド", systemImage: "chart.line.uptrend.xyaxis.circle.fill")
                    .foregroundColor(selectedTab == .trend ? .blue : .none)
                    .onTapGesture {
                        selectedTab = .trend
                    }
                Spacer()
                Divider()
                Spacer()
                Label("最新", systemImage: "clock.fill")
                    .foregroundColor(selectedTab == .recent ? .blue : .none)
                    .onTapGesture {
                        selectedTab = .recent
                    }
                Spacer()
            }
        }
    }
}
