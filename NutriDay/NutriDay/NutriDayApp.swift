//
//  NutriDayApp.swift
//  NutriDay
//
//  Created by Modibo on 13/03/2026.
//

import SwiftUI
internal import CoreData

@main
struct NutriDayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let dayViewModel = DayViewModel()
            TabView {
                HomeView(dayViewModel: dayViewModel)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Journal")
                    }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

