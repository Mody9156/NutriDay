//
//  MealsListView.swift
//  NutriDay
//
//  Created by Modibo on 16/03/2026.
//

import SwiftUI

// MARK: - Meals List
struct MealsListView: View {
    var dayViewModel: DayViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Repas")
                .font(.headline)
                .padding(.horizontal, 4)
            
            if vm.meals.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "fork.knife")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Aucun repas enregistré")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(32)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                ForEach(vm.meals) { meal in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(meal.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(
                                meal.date
                                    .formatted(
                                        date: .omitted,
                                        time: .shortened
                                    )
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(Int(meal.calories)) kcal")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                    }
                    .padding(14)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
                    .swipeActions {
                        Button(role: .destructive) {
                            vm.deleteMeal(meal)
                        } label: {
                            Label("Supprimer", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    MealsListView()
}
