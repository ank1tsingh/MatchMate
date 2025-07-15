//
//  APIServiceProtocol.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func fetchUsers(count: Int) -> AnyPublisher<[User], APIError>
    func fetchUsersWithRetry(count: Int, maxRetries: Int) -> AnyPublisher<[User], APIError>
}

struct APIConstants {
    static let baseURL = "https://randomuser.me/api/"
    static let resultsCount = 10
    static let timeoutInterval: TimeInterval = 30.0
}

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case serverError(Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}

