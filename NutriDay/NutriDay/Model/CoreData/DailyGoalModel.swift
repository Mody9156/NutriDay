//
//  DailyGoalModel.swift
//  NutriDay
//
//  Created by Modibo on 20/03/2026.
//

import Foundation

/// Modèle simple représentant l'objectif quotidien.
struct DailyGoalModel: Identifiable, Equatable {
    var id: UUID = UUID()
    var targetCalories: Double
}
