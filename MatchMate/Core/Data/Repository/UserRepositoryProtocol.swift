//
//  UserRepositoryProtocol.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Combine

protocol UserRepositoryProtocol {
    func fetchUsersFromAPI() -> AnyPublisher<[MatchUser], Error>
    func getCachedUsers() -> AnyPublisher<[MatchUser], Error>
    func updateMatchStatus(userID: String, status: MatchStatus) -> AnyPublisher<Void, Error>
    func saveUsers(_ users: [MatchUser]) -> AnyPublisher<Void, Error>
}
