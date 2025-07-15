//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import SwiftUI

@main
struct MatchMateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(persistenceController)
        }
    }
}
