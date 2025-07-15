//
//  ProfileListView.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileListView: View {
    @StateObject private var viewModel: ProfileListViewModel
    
    init() {
        let repository = UserRepository()
        let fetchUsersUseCase = FetchUsersUseCase(repository: repository)
        let updateMatchStatusUseCase = UpdateMatchStatusUseCase(repository: repository)
        
        self._viewModel = StateObject(wrappedValue: ProfileListViewModel(
            fetchUsersUseCase: fetchUsersUseCase,
            updateMatchStatusUseCase: updateMatchStatusUseCase
        ))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                
                switch viewModel.state {
                case .idle, .loading:
                    loadingView
                case .loaded:
                    if viewModel.shouldShowEmptyState {
                        emptyStateView
                    } else {
                        profilesList
                    }
                case .error(let message):
                    errorView(message: message)
                }
            }
            .navigationTitle("Profile Matches")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    refreshButton
                }
            }
            .refreshable {
                viewModel.refreshData()
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(.systemBackground),
                Color(.systemGray6)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Finding perfect matches...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.circle")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("No Matches Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Pull to refresh and discover new profiles")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Refresh Now") {
                viewModel.refreshData()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 40)
    }
    
    private var profilesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.users) { user in
                    ProfileCardView(user: user) { updatedUser, status in
                        viewModel.updateMatchStatus(for: updatedUser, status: status)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Oops! Something went wrong")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                viewModel.loadUsers()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 40)
    }
    
    private var refreshButton: some View {
        Button(action: {
            viewModel.refreshData()
        }) {
            Image(systemName: "arrow.clockwise")
                .font(.title3)
        }
        .disabled(viewModel.state.isLoading)
    }
}
