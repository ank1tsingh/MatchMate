//
//  ProfileCardViewModel.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Foundation
import Combine
import SwiftUI

class ProfileCardViewModel: ObservableObject {
    
    @Published var user: MatchUser
    
    init(user: MatchUser) {
        self.user = user
    }
    
    var displayName: String {
        user.name
    }
    
    var displayAge: String {
        "\(user.age)"
    }
    
    var displayLocation: String {
        user.location
    }
    
    var ageLocationText: String {
        "\(user.age), \(user.location)"
    }
    
    var statusText: String {
        user.matchStatus.displayText
    }
    
    var canShowActions: Bool {
        user.matchStatus == .pending
    }
    
    var statusColor: Color {
        switch user.matchStatus {
        case .pending:
            return .blue
        case .accepted:
            return .green
        case .declined:
            return .red
        }
    }
}
