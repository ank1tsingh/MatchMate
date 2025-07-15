//
//  FetchUsersUseCase.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Foundation
import Combine

protocol FetchUsersUseCaseProtocol {
    func execute(forceRefresh: Bool) -> AnyPublisher<[MatchUser], Error>
}

class FetchUsersUseCase: FetchUsersUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(forceRefresh: Bool = false) -> AnyPublisher<[MatchUser], Error> {
        if forceRefresh {
            return repository.fetchUsersFromAPI()
                .catch { [weak self] _ -> AnyPublisher<[MatchUser], Error> in
                    return self?.repository.getCachedUsers() ??
                    Fail(error: RepositoryError.noDataAvailable).eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        } else {
            return repository.getCachedUsers()
                .catch { [weak self] _ -> AnyPublisher<[MatchUser], Error> in
                    return self?.repository.fetchUsersFromAPI() ??
                    Fail(error: RepositoryError.noDataAvailable).eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
    }
}
