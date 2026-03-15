//
//  NutriDayApp.swift
//  NutriDay
//
//  Created by Modibo on 13/03/2026.
//

import SwiftUI
import CoreData

@main
struct NutriDayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView(
                vm: DayViewModel(
                    persistence: DayPersistenceModel(
                        context: persistenceController.container.viewContext
                    )
                )
            )
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
