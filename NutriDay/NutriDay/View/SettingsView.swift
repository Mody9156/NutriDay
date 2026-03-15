//
//  SettingsView.swift
//  NutriDay
//
//  Created by Modibo on 14/03/2026.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    var vm: DayViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var target = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Objectif calorique") {
                    HStack {
                        TextField("Ex: 2000", text: $target)
                            .keyboardType(.numberPad)
                        Text("kcal")
                            .foregroundStyle(.secondary)
                    }
                }
                Section {
                    Text("Objectif actuel : \(Int(vm.targetCalories)) kcal")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Paramètres")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Enregistrer") {
                        if let value = Double(target) {
                            vm.saveGoal(value)
                        }
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(Double(target) == nil)
                }
            }
            .onAppear {
                target = "\(Int(vm.targetCalories))"
            }
        }
    }
}

#Preview {
    SettingsView(vm: DayViewModel(persistence: DayPersistenceModel(context:PersistenceController.shared.container
        .viewContext)))
}
