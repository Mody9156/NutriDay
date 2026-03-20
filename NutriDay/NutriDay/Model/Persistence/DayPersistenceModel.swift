//  DayPersistenceModel.swift
//  NutriDay
//  Gère toutes les opérations Core Data pour les meals et goals

import Foundation
import CoreData

// MARK: - Erreurs de persistance

/// Erreurs possibles lors des opérations Core Data.
enum PersistenceError: Error, LocalizedError {
    case fetchFailed(entity: String, underlying: Error)
    case saveFailed(underlying: Error)
    case deleteFailed(entity: String, underlying: Error)
    case invalidData(entity: String)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let entity, let error):
            return "Échec de la récupération de '\(entity)' : \(error.localizedDescription)"
        case .saveFailed(let error):
            return "Échec de la sauvegarde : \(error.localizedDescription)"
        case .deleteFailed(let entity, let error):
            return "Échec de la suppression de '\(entity)' : \(error.localizedDescription)"
        case .invalidData(let entity):
            return "Données invalides ou incomplètes pour '\(entity)'"
        }
    }
}

// MARK: - Service de persistance

/// Service de persistance pour les repas et objectifs quotidiens.
class DayPersistenceModel {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Meals

    func fetchMeals(for date: Date) throws -> [MealModel] {
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            start as CVarArg, end as CVarArg
        )
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            let result = try context.fetch(request)
            return result.compactMap { meal in
                guard let id = meal.id, let name = meal.name, let date = meal.date else {
                    print("⚠️ Meal ignoré : données invalides — \(PersistenceError.invalidData(entity: "Meal").errorDescription ?? "")")
                    return nil
                }
                return MealModel(id: id, name: name, calories: meal.calories, date: date)
            }
        } catch {
            throw PersistenceError.fetchFailed(entity: "Meal", underlying: error)
        }
    }

    func addMeal(_ meal: MealModel) throws {
        let entity = Meal(context: context)
        entity.id = meal.id
        entity.name = meal.name
        entity.calories = meal.calories
        entity.date = meal.date
        try saveContext()
    }

    func deleteMeal(_ meal: MealModel) throws {
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", meal.id as CVarArg)

        do {
            let objects = try context.fetch(request)
            for obj in objects { context.delete(obj) }
            try saveContext()
        } catch let error as PersistenceError {
            throw error
        } catch {
            throw PersistenceError.deleteFailed(entity: "Meal", underlying: error)
        }
    }

    // MARK: - Goal

    func fetchGoal() throws -> DailyGoalModel? {
        let request: NSFetchRequest<DailyGoal> = DailyGoal.fetchRequest()

        do {
            let result = try context.fetch(request)
            guard let goal = result.first else { return nil }
            guard let id = goal.id else {
                throw PersistenceError.invalidData(entity: "DailyGoal")
            }
            return DailyGoalModel(id: id, targetCalories: goal.targetCalories)
        } catch let error as PersistenceError {
            throw error
        } catch {
            throw PersistenceError.fetchFailed(entity: "DailyGoal", underlying: error)
        }
    }

    func saveGoal(_ goalModel: DailyGoalModel) throws {
        let request: NSFetchRequest<DailyGoal> = DailyGoal.fetchRequest()

        do {
            let goal = (try context.fetch(request).first) ?? DailyGoal(context: context)
            goal.id = goalModel.id
            goal.targetCalories = goalModel.targetCalories
            try saveContext()
        } catch let error as PersistenceError {
            throw error
        } catch {
            throw PersistenceError.saveFailed(underlying: error)
        }
    }

    // MARK: - Utilitaires

    private func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            throw PersistenceError.saveFailed(underlying: error)
        }
    }
}
