//
//  PersistenceController.swift
//  NutriDay
//
//  Created by Modibo on 13/03/2026.
//

import Foundation
import CoreData

class NutriPersistenceController {
    static let shared = PersistenceController()

        let container: NSPersistentContainer

        init() {
            container = NSPersistentContainer(name: "NutriDay")
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Core Data error: \(error)")
                }
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
}
