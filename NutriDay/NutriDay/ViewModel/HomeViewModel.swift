//  HomeViewModel.swift
//  NutriDay
//
//  Created for view separation.

import Foundation
import Observation

@Observable
class HomeViewModel {
    let persistence: DayPersistenceModel

    var meals: [MealModel] = []
    var selectedDate: Date = Date()
    var streak: Int = 0

    init(persistence: DayPersistenceModel) {
        self.persistence = persistence
        fetchMeals()
        calculateStreak()
    }

    var totalCalories: Double {
        meals.reduce(0) { $0 + $1.calories }
    }

    var targetCalories: Double {
        persistence.fetchGoal()?.targetCalories ?? 2000
    }

    var progress: Double {
        min(totalCalories / targetCalories, 1.0)
    }

    // MARK: - Meals
    func fetchMeals() {
        meals = persistence.fetchMeals(for: selectedDate)
    }

    func addMeal(name: String, calories: Double) {
        let meal = MealModel(name: name, calories: calories, date: selectedDate)
        persistence.addMeal(meal)
        fetchMeals()
        calculateStreak()
    }

    func deleteMeal(_ meal: MealModel) {
        persistence.deleteMeal(meal)
        fetchMeals()
        calculateStreak()
    }

    // MARK: - Streak
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

    // MARK: - Navigation
    func changeDay(by value: Int) {
        selectedDate = Calendar.current.date(
            byAdding: .day, value: value, to: selectedDate
        ) ?? selectedDate
        fetchMeals()
        calculateStreak()
    }
}
