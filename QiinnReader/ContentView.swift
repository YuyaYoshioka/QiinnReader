//
//  ContentView.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/15.
//

import SwiftUI

struct ContentView: View {
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        TabView {
            QiitaItemsView()
                .tabItem {
                    Label("Qiita", systemImage: "q.circle.fill")
                }
            QiitaAccountView()
                .tabItem {
                    Label("アカウント", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
