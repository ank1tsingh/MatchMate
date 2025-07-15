//
//  APIResponse.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Foundation


struct APIResponse: Codable {
    let results: [User]
    let info: APIInfo
}

struct APIInfo: Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}
