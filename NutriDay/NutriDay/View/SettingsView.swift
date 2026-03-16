//
//  SettingsView.swift
//  NutriDay
//
//  Created by Modibo on 14/03/2026.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    var settingsViewModel = SettingsViewModel(persistence: DayPersistenceModel(context: PersistenceController.shared.container.viewContext))
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
                    Text("Objectif actuel : \(Int(settingsViewModel.targetCalories)) kcal")
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
                            settingsViewModel.saveGoal(value)
                        }
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(Double(target) == nil)
                }
            }
            .onAppear {
                target = "\(Int(settingsViewModel.targetCalories))"
            }
        }
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel(persistence: DayPersistenceModel(context: PersistenceController.shared.container.viewContext)))
}
