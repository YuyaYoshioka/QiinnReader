//
//  QiinnReaderApp.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/15.
//

import SwiftUI

@main
struct QiinnReaderApp: App {
    @StateObject private var indicatorControl = IndicatorControl.shared
        
    var body: some Scene {
        WindowGroup {
            ZStack {
                if indicatorControl.isShow {
                    ProgressView().zIndex(10)
                }
                ContentView()
                    .background(Color(red: 239/255, green: 239/255, blue: 239/255))
            }
        }
    }
}
