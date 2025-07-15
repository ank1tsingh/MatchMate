//
//  ActionButtonsView.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import SwiftUI

struct ActionButtonsView: View {
    let user: MatchUser
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            if user.matchStatus == .pending {
                Button(action: onDecline) {
                    ActionButton(
                        title: "Decline",
                        icon: "xmark",
                        color: .red
                    )
                }
                
                Button(action: onAccept) {
                    ActionButton(
                        title: "Accept",
                        icon: "checkmark",
                        color: .green
                    )
                }
            } else {
                StatusButton(status: user.matchStatus)
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.headline)
            Text(title)
                .font(.headline)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct StatusButton: View {
    let status: MatchStatus
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: statusIcon)
                .font(.headline)
            Text(status.buttonText)
                .font(.headline)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(statusColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var statusIcon: String {
        switch status {
        case .accepted:
            return "checkmark.circle.fill"
        case .declined:
            return "xmark.circle.fill"
        case .pending:
            return "clock.circle.fill"
        }
    }
    
    private var statusColor: Color {
        switch status {
        case .accepted:
            return .green
        case .declined:
            return .red
        case .pending:
            return .blue
        }
    }
}
