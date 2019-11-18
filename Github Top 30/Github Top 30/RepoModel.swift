//
//  RepoModel.swift
//  Github Top 30
//
//  Created by Kiran Kumar on 16/11/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

import Foundation

struct RepoModel {
    var repoName: String?
    var repoDescription: String?
    var repoOwnerName: String?
    var repoAvatarURL: String?
    var stargazersCount: String?
    
    init(dict: [String: Any]) {
        repoName = dict["name"] as? String
        repoDescription = dict["description"] as? String
        
        if let owner = dict["owner"] as? [String: Any] {
            repoOwnerName = owner["login"] as? String
            repoAvatarURL = owner["avatar_url"] as? String
        }
        
        if let count = dict["stargazers_count"] as? Int {
            if count > 1000 {
                stargazersCount = String(format: "%.1fk", Float(count)/1000)
            } else {
                stargazersCount = "\(count)"
            }
        }
    }
}
