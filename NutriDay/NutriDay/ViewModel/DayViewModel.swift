//  DayViewModel.swift
//  NutriDay
//
//  Created by Modibo on 13/03/2026.

import Foundation
import Observation
import SwiftUI
internal import CoreData

// MARK: - Erreurs du ViewModel

/// Erreurs possibles dans le DayViewModel.
enum DayViewModelError: Error, LocalizedError {
    case fetchMealsFailed(underlying: Error)
    case addMealFailed(underlying: Error)
    case deleteMealFailed(underlying: Error)
    case fetchGoalFailed(underlying: Error)
    case saveGoalFailed(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .fetchMealsFailed(let error):
            return "Impossible de récupérer les repas : \(error.localizedDescription)"
        case .addMealFailed(let error):
            return "Impossible d'ajouter le repas : \(error.localizedDescription)"
        case .deleteMealFailed(let error):
            return "Impossible de supprimer le repas : \(error.localizedDescription)"
        case .fetchGoalFailed(let error):
            return "Impossible de récupérer l'objectif : \(error.localizedDescription)"
        case .saveGoalFailed(let error):
            return "Impossible de sauvegarder l'objectif : \(error.localizedDescription)"
        }
    }
}

@Observable
class DayViewModel {
    var persistence: DayPersistenceModel

    var meals: [MealModel] = []
    var targetCalories: Double = 2000
    var selectedDate: Date = Date()
    var streak: Int = 0

    /// Dernière erreur survenue, observable par la View pour afficher une alerte.
    var lastError: DayViewModelError?

    init(persistence: DayPersistenceModel = DayPersistenceModel(context: PersistenceController.shared.container.viewContext)) {
        self.persistence = persistence
        loadGoal()
        fetchMeals()
        calculateStreak()
    }

    var totalCalories: Double {
        meals.reduce(0) { $0 + $1.calories }
    }

    var progress: Double {
        min(totalCalories / targetCalories, 1.0)
    }

    var isUnderGoal: Bool {
        totalCalories <= targetCalories
    }

    // MARK: - Meals

    func fetchMeals() {
        do {
            meals = try persistence.fetchMeals(for: selectedDate)
        } catch {
            lastError = .fetchMealsFailed(underlying: error)
            print("❌ \(lastError!.errorDescription ?? "")")
        }
    }

    func addMeal(name: String, calories: Double) {
        let meal = MealModel(name: name, calories: calories, date: selectedDate)
        do {
            try persistence.addMeal(meal)
            fetchMeals()
            calculateStreak()
        } catch {
            lastError = .addMealFailed(underlying: error)
            print("❌ \(lastError!.errorDescription ?? "")")
        }
    }

    func deleteMeal(_ meal: MealModel) {
        do {
            try persistence.deleteMeal(meal)
            fetchMeals()
            calculateStreak()
        } catch {
            lastError = .deleteMealFailed(underlying: error)
            print("❌ \(lastError!.errorDescription ?? "")")
        }
    }

    // MARK: - Goal

    func loadGoal() {
        do {
            targetCalories = try persistence.fetchGoal()?.targetCalories ?? 2000
        } catch {
            lastError = .fetchGoalFailed(underlying: error)
            print("❌ \(lastError!.errorDescription ?? "")")
        }
    }

    func saveGoal(_ calories: Double) {
        let goal = DailyGoalModel(targetCalories: calories)
        do {
            try persistence.saveGoal(goal)
            targetCalories = calories
            fetchMeals()
            calculateStreak()
        } catch {
            lastError = .saveGoalFailed(underlying: error)
            print("❌ \(lastError!.errorDescription ?? "")")
        }
    }

    // MARK: - Stats (pour StatsView)

    func fetchMealsPublic(for date: Date) -> [MealModel] {
        do {
            return try persistence.fetchMeals(for: date)
        } catch {
            lastError = .fetchMealsFailed(underlying: error)
            print("❌ \(lastError!.errorDescription ?? "")")
            return []
        }
    }

    func weekData() -> [(date: Date, calories: Double)] {
        (0..<7).reversed().map { offset in
            let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date())!
            let meals = (try? persistence.fetchMeals(for: date)) ?? []
            return (date: date, calories: meals.reduce(0) { $0 + $1.calories })
        }
    }

    // MARK: - Streak

    func calculateStreak() {
        var count = 0
        var date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        for _ in 0..<30 {
            let meals = (try? persistence.fetchMeals(for: date)) ?? []
            let total = meals.reduce(0) { $0 + $1.calories }
            if total > 0 && total <= targetCalories {
                count += 1
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            } else {
                break
            }
        }
        streak = count
    }

    func currentStreak() -> Int {
        var count = 0
        var date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        for _ in 0..<30 {
            let meals = (try? persistence.fetchMeals(for: date)) ?? []
            let total = meals.reduce(0) { $0 + $1.calories }
            if total > 0 && total <= targetCalories {
                count += 1
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            } else {
                break
            }
        }
        return count
    }

    // MARK: - Navigation

    func changeDay(by value: Int) {
        selectedDate = Calendar.current.date(
            byAdding: .day, value: value, to: selectedDate
        ) ?? selectedDate
        fetchMeals()
    }
}
