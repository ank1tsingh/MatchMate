//
//  UserRepository.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Foundation
import Combine

class UserRepository: UserRepositoryProtocol {
    private let apiService: APIServiceProtocol
    private let coreDataManager: CoreDataManager
    
    init(apiService: APIServiceProtocol = APIService(),
         coreDataManager: CoreDataManager = CoreDataManager()) {
        self.apiService = apiService
        self.coreDataManager = coreDataManager
    }
    
    func fetchUsersFromAPI() -> AnyPublisher<[MatchUser], Error> {
        return apiService.fetchUsers(count: APIConstants.resultsCount)
            .map { users in
                users.map { MatchUser(from: $0) }
            }
            .mapError{ apiError in
                RepositoryError.apiError(apiError) as Error
            }
            .flatMap { [weak self] matchUsers -> AnyPublisher<[MatchUser], Error> in
                guard let self = self else {
                    return Just(matchUsers).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                return self.saveUsers(matchUsers)
                    .map { matchUsers }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getCachedUsers() -> AnyPublisher<[MatchUser], Error> {
        return coreDataManager.fetchUsers()
            .mapError { error in
                RepositoryError.cacheError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func updateMatchStatus(userID: String, status: MatchStatus) -> AnyPublisher<Void, Error> {
        return coreDataManager.updateUserMatchStatus(userID, status: status)
            .mapError { error in
                RepositoryError.cacheError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func saveUsers(_ users: [MatchUser]) -> AnyPublisher<Void, Error> {
        let savePublishers = users.map { user in
            coreDataManager.saveUser(user)
        }
        
        return Publishers.MergeMany(savePublishers)
            .collect()
            .map { _ in () }
            .mapError { error in
                RepositoryError.cacheError(error)
            }
            .eraseToAnyPublisher()
    }
}



enum RepositoryError: Error {
    case apiError(APIError)
    case cacheError(Error)
    case noDataAvailable
    case unknownError(Error)
    
    var localizedDescription: String {
        switch self {
        case .apiError(let apiError):
            return "API Error: \(apiError.localizedDescription)"
        case .cacheError(let error):
            return "Cache Error: \(error.localizedDescription)"
        case .noDataAvailable:
            return "No data available"
        case .unknownError(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
