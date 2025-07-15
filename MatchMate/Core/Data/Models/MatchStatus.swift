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

// MARK: - MatchUser.swift (Domain Entity)
struct MatchUser: Identifiable, Equatable {
    let id: String
    let name: String
    let age: Int
    let location: String
    let profileImageURL: String
    let email: String
    let phone: String
    var matchStatus: MatchStatus
    
    // Convert from API User model
    init(from user: User, status: MatchStatus = .pending) {
        self.id = user.userId
        self.name = user.name.fullName
        self.age = user.dob.age
        self.location = user.location.displayLocation
        self.profileImageURL = user.picture.large
        self.email = user.email
        self.phone = user.phone
        self.matchStatus = status
    }
    
    // For Core Data conversion
    init(id: String, name: String, age: Int, location: String,
         profileImageURL: String, email: String, phone: String,
         matchStatus: MatchStatus) {
        self.id = id
        self.name = name
        self.age = age
        self.location = location
        self.profileImageURL = profileImageURL
        self.email = email
        self.phone = phone
        self.matchStatus = matchStatus
    }
    
    static func == (lhs: MatchUser, rhs: MatchUser) -> Bool {
        return lhs.id == rhs.id
    }
}
