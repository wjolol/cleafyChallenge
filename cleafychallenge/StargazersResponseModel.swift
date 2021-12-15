//
//  StargazersResponseModel.swift
//  cleafychallenge
//
//  Created by SERTORIG on 14/12/21.
//

import Foundation

//MARK: - Here we have the model for the response of the api https://api.github.com/repos/owner/repoName/stargazers
struct StargazersResponseModel: Codable {
    var login: String
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
    }
}
