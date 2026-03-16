//  SettingsViewModel.swift
//  NutriDay
//  Created for view separation.

import Foundation
import Observation

@Observable
class SettingsViewModel {
    let persistence: DayPersistenceModel
    
    var targetCalories: Double = 2000
    
    init(persistence: DayPersistenceModel) {
        self.persistence = persistence
        loadGoal()
    }
    
    func loadGoal() {
        targetCalories = persistence.fetchGoal()?.targetCalories ?? 2000
    }
    
    func saveGoal(_ calories: Double) {
        let goal = DailyGoalModel(targetCalories: calories)
        persistence.saveGoal(goal)
        targetCalories = calories
    }
}
