//
//  QiitaModel.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/18.
//

import Foundation

// FYI: https://qiita.com/api/v2/docs

let qiitaBaseURL = "https://qiita.com/api/v2"

struct QiitaItem: Codable, Identifiable {
    var renderedBody: String
    var body: String
    var coediting: Bool
    var commentsCount: Int
    var createdAt: String
    var id: String
    var likesCount: Int
    var `private`: Bool
    var stocksCount: Int
    var tags: [QiitaItemTag]
    var title: String
    var updatedAt: String
    var url: String
    var user: QiitaUser
    var pageViewsCount: Int?
    
    struct QiitaItemTag: Codable {
        var name: String
        var versions: [String]
    }
}

extension QiitaItem {
    func createTagNames() -> String {
        let names = tags.map(\.name)
        let namesStr = names.joined(separator: ",")
        
        return namesStr
    }
}

struct QiitaUser: Codable, Identifiable {
    var description: String?
    var facebookId: String?
    var followeesCount: Int
    var followersCount: Int
    var githubLoginName: String?
    var id: String
    var itemsCount: Int
    var linkedinId: String?
    var location: String?
    var name: String?
    var organization: String?
    var permanentId: Int
    var profileImageUrl: String
    var teamOnly: Bool
    var twitterScreenName: String?
    var websiteUrl: String?
}
