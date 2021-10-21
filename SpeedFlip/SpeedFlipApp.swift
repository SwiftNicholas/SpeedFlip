//
//  SpeedFlipApp.swift
//  SpeedFlip
//
//  Created by Nicholas Verrico on 10/21/21.
//

import SwiftUI

@main
struct SpeedFlipApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
