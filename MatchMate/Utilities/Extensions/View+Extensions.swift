//
//  View+Extensions.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Foundation
import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.cardShadow, radius: 8, x: 0, y: 4)
    }
}
