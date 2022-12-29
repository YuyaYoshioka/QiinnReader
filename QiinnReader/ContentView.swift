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
        QiitaItemsView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
