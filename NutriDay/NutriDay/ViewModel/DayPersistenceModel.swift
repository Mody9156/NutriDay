//  DayPersistenceModel.swift
//  NutriDay
//  Gère toutes les opérations Core Data pour les meals et goals

import Foundation
import CoreData

/// Service de persistance pour les repas et objectifs quotidiens.
class DayPersistenceModel {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Meals
    func fetchMeals(for date: Date) -> [MealModel] {
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            start as CVarArg, end as CVarArg
        )
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        guard let result = try? context.fetch(request) else { return [] }
        return result.compactMap { meal in
            guard let id = meal.id, let name = meal.name, let date = meal.date else { return nil }
            return MealModel(id: id, name: name, calories: meal.calories, date: date)
        }
    }

    func addMeal(_ meal: MealModel) {
        let entity = Meal(context: context)
        entity.id = meal.id
        entity.name = meal.name
        entity.calories = meal.calories
        entity.date = meal.date
        saveContext()
    }

    func deleteMeal(_ meal: MealModel) {
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", meal.id as CVarArg)
        if let objects = try? context.fetch(request) {
            for obj in objects { context.delete(obj) }
            saveContext()
        }
    }

    // MARK: - Goal
    func fetchGoal() -> DailyGoalModel? {
        let request: NSFetchRequest<DailyGoal> = DailyGoal.fetchRequest()
        if let goal = try? context.fetch(request).first, let id = goal.id {
            return DailyGoalModel(id: id, targetCalories: goal.targetCalories)
        }
        return nil
    }

    func saveGoal(_ goalModel: DailyGoalModel) {
        let request: NSFetchRequest<DailyGoal> = DailyGoal.fetchRequest()
        let goal = (try? context.fetch(request).first) ?? DailyGoal(context: context)
        goal.id = goalModel.id
        goal.targetCalories = goalModel.targetCalories
        saveContext()
    }

    // MARK: - Utilitaires
    private func saveContext() {
        try? context.save()
    }
}
