//
//  QiitaModel.swift
//  QiinnReader
//
//  Created by 吉岡雄也 on 2022/12/18.
//

import Foundation

// FYI: https://qiita.com/api/v2/docs

let qiitaBaseURL = "https://qiita.com"
let qiitaAPIBaseURL = qiitaBaseURL + "/api/v2"

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

struct QiitaPopularItem {
    var entry: Entry
    var author: Author
    
    struct Entry {
        var id: String
        var published: String
        var updated: String
        var link: String
        var title: String
        var content: String
        
    }
    
    struct Author {
        var name: String
    }
}

extension QiitaPopularItem {
    func createID() -> String? {
        let linkArray = entry.link.split(separator: "/")
        guard let index = linkArray.firstIndex(of: "items") else { return nil }
        let idWithQueryParameter = linkArray[index + 1]
        guard let id = idWithQueryParameter.split(separator: "?").first else { return nil }
        
        return String(id)
    }
}

struct QiitaAccessToken: Decodable {
    var clientId: String
    var scopes: [String]
    var token: String
}

struct QiitaAuthenticatedUser: Decodable {
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
    var imageMonthlyUploadLimit: Int
    var imageMonthlyUploadRemaining: Int
}
