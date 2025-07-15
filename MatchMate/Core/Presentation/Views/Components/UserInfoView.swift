//
//  UserInfoView.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import SwiftUI

struct UserInfoView: View {
    let user: MatchUser
    let showDetailedInfo: Bool
    
    init(user: MatchUser, showDetailedInfo: Bool = false) {
        self.user = user
        self.showDetailedInfo = showDetailedInfo
    }
    
    var body: some View {
        VStack(spacing: showDetailedInfo ? 12 : 8) {
            Text(user.name)
                .font(showDetailedInfo ? .title : .title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("\(user.age), \(user.location)")
                .font(showDetailedInfo ? .body : .subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if showDetailedInfo {
                VStack(spacing: 4) {
                    Label(user.email, systemImage: "envelope")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label(user.phone, systemImage: "phone")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, showDetailedInfo ? 16 : 12)
        .padding(.horizontal, 20)
    }
}
