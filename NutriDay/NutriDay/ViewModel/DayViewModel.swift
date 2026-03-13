//
//  DayViewModel.swift
//  NutriDay
//
//  Created by Modibo on 13/03/2026.
//

import Foundation
import Observation
import CoreData
import SwiftUI

@Observable
class DayViewModel {
    private let context: NSManagedObjectContext

     var meals: [Meal] = []
     var targetCalories: Double = 2000
     var selectedDate: Date = Date()
     var streak: Int = 0

    init(context: NSManagedObjectContext) {
        self.context = context
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
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        let start = Calendar.current.startOfDay(for: selectedDate)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            start as CVarArg, end as CVarArg
        )
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        meals = (try? context.fetch(request)) ?? []
    }

    func addMeal(name: String, calories: Double) {
        let meal = Meal(context: context)
        meal.id = UUID()
        meal.name = name
        meal.calories = calories
        meal.date = selectedDate
        save()
    }

    func deleteMeal(_ meal: Meal) {
        context.delete(meal)
        save()
    }

    // MARK: - Goal
    func loadGoal() {
        let request: NSFetchRequest<DailyGoal> = DailyGoal.fetchRequest()
        if let goal = try? context.fetch(request).first {
            targetCalories = goal.targetCalories
        }
    }

    func saveGoal(_ calories: Double) {
        let request: NSFetchRequest<DailyGoal> = DailyGoal.fetchRequest()
        let goal = (try? context.fetch(request).first) ?? DailyGoal(context: context)
        goal.id = UUID()
        goal.targetCalories = calories
        targetCalories = calories
        save()
    }

    // MARK: - Streak
    func calculateStreak() {
        var count = 0
        var date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        for _ in 0..<30 {
            let meals = fetchMealsFor(date: date)
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

    private func fetchMealsFor(date: Date) -> [Meal] {
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            start as CVarArg, end as CVarArg
        )
        return (try? context.fetch(request)) ?? []
    }

    // MARK: - Save
    private func save() {
        try? context.save()
        fetchMeals()
        calculateStreak()
    }

    func changeDay(by value: Int) {
        selectedDate = Calendar.current.date(
            byAdding: .day, value: value, to: selectedDate
        ) ?? selectedDate
        fetchMeals()
    }
}
