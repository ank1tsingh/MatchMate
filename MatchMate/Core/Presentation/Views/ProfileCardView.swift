//
//  ProfileCardView.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import SwiftUI
import SDWebImageSwiftUI


struct ProfileCardView: View {
    @StateObject private var viewModel: ProfileCardViewModel
    let onStatusChange: (MatchUser, MatchStatus) -> Void
    
    @State private var isProcessing = false
    @State private var localStatus: MatchStatus
    @State private var buttonScale: CGFloat = 1.0
    
    init(user: MatchUser, onStatusChange: @escaping (MatchUser, MatchStatus) -> Void) {
        self._viewModel = StateObject(wrappedValue: ProfileCardViewModel(user: user))
        self.onStatusChange = onStatusChange
        self._localStatus = State(initialValue: user.matchStatus)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            profileImageSection
            userInfoSection
            actionButtonsSection
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .scaleEffect(buttonScale)
        .onChange(of: viewModel.user.matchStatus) { newStatus in
            withAnimation(.easeInOut(duration: 0.3)) {
                localStatus = newStatus
            }
        }
    }
    
    private var profileImageSection: some View {
        WebImage(url: URL(string: viewModel.user.profileImageURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: ContentMode.fill)
        } placeholder: {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    VStack(spacing: 8) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Loading...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                )
        }
        .onSuccess { image, data, cacheType in
            print("Image loaded successfully")
        }
        .onFailure { error in
            print("Failed to load image: \(error)")
        }
        .indicator(.activity)
        .transition(.fade(duration: 0.5))
        .frame(height: 300)
        .clipped()
    }
    
    private var userInfoSection: some View {
        VStack(spacing: 12) {
            Text(viewModel.displayName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(viewModel.ageLocationText)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            if localStatus == .pending {
                // Decline 
                Button(action: {
                    handleButtonTap(status: .declined)
                }) {
                    HStack(spacing: 8) {
                        if isProcessing && localStatus == .declined {
                            ProgressView()
                                .scaleEffect(0.8)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "xmark")
                        }
                        Text("Decline")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(isProcessing)
                .scaleEffect(isProcessing && localStatus == .declined ? 0.95 : 1.0)
                
                // Accept
                Button(action: {
                    handleButtonTap(status: .accepted)
                }) {
                    HStack(spacing: 8) {
                        if isProcessing && localStatus == .accepted {
                            ProgressView()
                                .scaleEffect(0.8)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "checkmark")
                        }
                        Text("Accept")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(isProcessing)
                .scaleEffect(isProcessing && localStatus == .accepted ? 0.95 : 1.0)
            } else {
                HStack(spacing: 8) {
                    Image(systemName: statusIcon)
                        .foregroundColor(.white)
                    Text(statusText)
                        .foregroundColor(.white)
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(statusColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: localStatus)
        .animation(.easeInOut(duration: 0.2), value: isProcessing)
    }
    
    private func handleButtonTap(status: MatchStatus) {
        withAnimation(.easeInOut(duration: 0.1)) {
            buttonScale = 0.95
        }
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            localStatus = status
            isProcessing = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                buttonScale = 1.0
            }
        }
        
        onStatusChange(viewModel.user, status)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isProcessing = false
            }
        }
        print("Button tapped: \(status) for \(viewModel.user.name)")
    }
    
    private var statusIcon: String {
        switch localStatus {
        case .accepted:
            return "checkmark.circle.fill"
        case .declined:
            return "xmark.circle.fill"
        case .pending:
            return "clock.circle.fill"
        }
    }
    
    private var statusText: String {
        switch localStatus {
        case .accepted:
            return "Member Accepted"
        case .declined:
            return "Member Declined"
        case .pending:
            return "Pending"
        }
    }
    
    private var statusColor: Color {
        switch localStatus {
        case .pending:
            return .blue
        case .accepted:
            return .green
        case .declined:
            return .red
        }
    }
}
