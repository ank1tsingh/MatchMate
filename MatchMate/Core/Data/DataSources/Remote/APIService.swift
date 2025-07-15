//
//  APIService.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Foundation
import Combine


enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

class APIService: APIServiceProtocol {
    private var session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIConstants.timeoutInterval
        configuration.timeoutIntervalForResource = APIConstants.timeoutInterval
        self.session = URLSession(configuration: configuration)
    }
    
    func fetchUsers(count: Int = APIConstants.resultsCount) -> AnyPublisher<[User], APIError> {
        guard let url = buildURL(for: count) else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: APIResponse.self, decoder: decoder)
            .map(\.results)
            .mapError { error in
                if error is DecodingError {
                    return APIError.decodingError
                } else if let urlError = error as? URLError {
                    return APIError.networkError(urlError)
                } else {
                    return APIError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchUsersWithRetry(count: Int = APIConstants.resultsCount, maxRetries: Int = 3) -> AnyPublisher<[User], APIError> {
        return fetchUsers(count: count)
            .retry(maxRetries)
            .eraseToAnyPublisher()
    }
    
    private func buildURL(for count: Int) -> URL? {
        var components = URLComponents(string: APIConstants.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "results", value: "\(count)")
        ]
        return components?.url
    }
}
