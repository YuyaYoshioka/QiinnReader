//
//  IndicatorControl.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/18.
//

import Foundation

final class IndicatorControl: ObservableObject {
    @Published var isShow = false
    
    static let shared = IndicatorControl()
    
    private init() {}
    
    func showLoading() {
        isShow = true
    }
    
    func hideLoading() {
        isShow = false
    }
}
