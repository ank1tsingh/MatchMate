//
//  ProfileListViewModel.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Foundation
import Combine


class ProfileListViewModel: ObservableObject {
    @Published var users: [MatchUser] = []
    @Published var state: ViewModelState = .idle
    
    private let fetchUsersUseCase: FetchUsersUseCaseProtocol
    private let updateMatchStatusUseCase: UpdateMatchStatusUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(fetchUsersUseCase: FetchUsersUseCaseProtocol,
         updateMatchStatusUseCase: UpdateMatchStatusUseCaseProtocol) {
        self.fetchUsersUseCase = fetchUsersUseCase
        self.updateMatchStatusUseCase = updateMatchStatusUseCase
        
        loadUsers()
    }
    
    func loadUsers(forceRefresh: Bool = false) {
        state = .loading
        
        fetchUsersUseCase.execute(forceRefresh: forceRefresh)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.state = .loaded
                    case .failure(let error):
                        self?.state = .error(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] users in
                    self?.users = users
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshData() {
        loadUsers(forceRefresh: true)
    }
    
    func updateMatchStatus(for user: MatchUser, status: MatchStatus) {
        updateUserInList(user, with: status)
        
        updateMatchStatusUseCase.execute(userID: user.id, status: status)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.revertUserStatus(user)
                        self?.state = .error(error.localizedDescription)
                    }
                },
                receiveValue: { }
            )
            .store(in: &cancellables)
    }
    
    private func updateUserInList(_ user: MatchUser, with status: MatchStatus) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index].matchStatus = status
        }
    }
    
    private func revertUserStatus(_ user: MatchUser) {
        updateUserInList(user, with: .pending)
    }
    
    var hasData: Bool {
        !users.isEmpty
    }
    
    var shouldShowEmptyState: Bool {
        users.isEmpty && state == .loaded
    }
}
