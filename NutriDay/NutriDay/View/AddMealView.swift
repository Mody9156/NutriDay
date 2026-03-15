//
//  AddMealView.swift
//  NutriDay
//
//  Created by Modibo on 14/03/2026.
//

import SwiftUI
import CoreData

struct AddMealView: View {
     var vm: DayViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var calories = ""

    var isValid: Bool {
        !name.isEmpty && Double(calories) != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Repas") {
                    TextField("Nom du repas", text: $name)
                    TextField("Calories (kcal)", text: $calories)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Ajouter un repas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Ajouter") {
                        vm.addMeal(name: name, calories: Double(calories) ?? 0)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
        }
    }
}
#Preview {
    AddMealView(vm: DayViewModel(persistence: DayPersistenceModel(
        context: PersistenceController.shared.container
            .viewContext)))
}
