//
//  QiitaKeyChain.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2023/01/12.
//

import Foundation
import KeychainAccess

final class QiitaKeyChain {
    private let key = "auth-token"
    private let keyChain = Keychain(service: "com.qiita.auth-token")

    private init() {}
    
    static let shared = QiitaKeyChain()
    
    func setAuthToken(token: String) {
        keyChain[key] = token
    }
    
    func getAuthToken() -> String? {
        keyChain[key]
    }
}
