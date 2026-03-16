//  StatsViewModel.swift
//  NutriDay
//  Created for view separation.

import Foundation
import Observation

@Observable
class StatsViewModel {
    let persistence: DayPersistenceModel

    let targetCalories: Double
    
    init(persistence: DayPersistenceModel) {
        self.persistence = persistence
        self.targetCalories = persistence.fetchGoal()?.targetCalories ?? 2000
    }
    
    // Retrieve calories data for 7 days
    func weekData() -> [(date: Date, calories: Double)] {
        (0..<7).reversed().map { offset in
            let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date())!
            let meals = persistence.fetchMeals(for: date)
            return (date: date, calories: meals.reduce(0) { $0 + $1.calories })
        }
    }
    
    // Calculate current streak
    func streak() -> Int {
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
        return count
    }
}
