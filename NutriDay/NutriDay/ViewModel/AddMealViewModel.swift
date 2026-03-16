//
//  AddMealViewModel.swift
//  NutriDay
//
//  Created by Modibo on 16/03/2026.
//

import Foundation
import Observation

@Observable
class AddMealViewModel {
    let persistence: DayPersistenceModel
    var selectedDate: Date = Date()
    var meals: [MealModel] = []
    var streak: Int = 0

    // MARK: - Init
    init(persistence: DayPersistenceModel, selectedDate: Date = Date()) {
        self.persistence = persistence
        self.selectedDate = selectedDate
        // Preload current state
        fetchMeals()
        calculateStreak()
    }
    
    // MARK: - Meals
    func fetchMeals() {
        meals = persistence.fetchMeals(for: selectedDate)
    }
    
    var targetCalories: Double {
        persistence.fetchGoal()?.targetCalories ?? 2000
    }
    
    func calculateStreak() {
        var count = 0
        var date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let target = targetCalories
        for _ in 0..<30 {
            let meals = persistence.fetchMeals(for: date)
            let total = meals.reduce(0) { $0 + $1.calories }
            if total > 0 && total <= target {
                count += 1
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            } else {
                break
            }
        }
        streak = count
    }
    
    func addMeal(name: String, calories: Double) {
        let meal = MealModel(name: name, calories: calories, date: selectedDate)
        persistence.addMeal(meal)
        fetchMeals()
        calculateStreak()
    }
}

