//
//  UpdateMatchStatusUseCase.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Combine
import Foundation

protocol UpdateMatchStatusUseCaseProtocol {
    func execute(userID: String, status: MatchStatus) -> AnyPublisher<Void, Error>
}

class UpdateMatchStatusUseCase: UpdateMatchStatusUseCaseProtocol {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userID: String, status: MatchStatus) -> AnyPublisher<Void, Error> {
        return repository.updateMatchStatus(userID: userID, status: status)
    }
}
