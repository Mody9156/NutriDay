//  DayViewModel.swift
//  NutriDay
//
//  Created by Modibo on 13/03/2026.

import Foundation
import Observation
import SwiftUI

@Observable
class DayViewModel {
    let persistence: DayPersistenceModel

    var meals: [MealModel] = []
    var targetCalories: Double = 2000
    var selectedDate: Date = Date()
    var streak: Int = 0

    init(persistence: DayPersistenceModel) {
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

    // MARK: - Goal
    func loadGoal() {
        targetCalories = persistence.fetchGoal()?.targetCalories ?? 2000
    }

    func saveGoal(_ calories: Double) {
        let goal = DailyGoalModel(targetCalories: calories)
        persistence.saveGoal(goal)
        targetCalories = calories
        fetchMeals()
        calculateStreak()
    }

    // MARK: - Stats (pour StatsView)
    func fetchMealsPublic(for date: Date) -> [MealModel] {
        persistence.fetchMeals(for: date)
    }

    // MARK: - Streak
    func calculateStreak() {
        var count = 0
        var date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        for _ in 0..<30 {
            let meals = persistence.fetchMeals(for: date)
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

    // MARK: - Navigation
    func changeDay(by value: Int) {
        selectedDate = Calendar.current.date(
            byAdding: .day, value: value, to: selectedDate
        ) ?? selectedDate
        fetchMeals()
    }
}
