//  DayModel.swift
//  NutriDay
//  Modèles de données simples pour la ViewModel (sans Core Data)

import Foundation

/// Modèle simple représentant un repas.
struct MealModel: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var calories: Double
    var date: Date
}

/// Modèle simple représentant l'objectif quotidien.
struct DailyGoalModel: Identifiable, Equatable {
    var id: UUID = UUID()
    var targetCalories: Double
}
