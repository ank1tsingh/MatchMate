//
//  MatchStatus.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Foundation

enum MatchStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case accepted = "accepted"
    case declined = "declined"
    
    var displayText: String {
        switch self {
        case .pending:
            return "Pending"
        case .accepted:
            return "Accepted"
        case .declined:
            return "Declined"
        }
    }
    
    var buttonText: String {
        switch self {
        case .pending:
            return "Pending"
        case .accepted:
            return "Member Accepted"
        case .declined:
            return "Member Declined"
        }
    }
}
