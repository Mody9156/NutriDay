//
//  HomeView.swift
//  NutriDay
//
//  Created by Modibo on 14/03/2026.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    var dayViewModel: DayViewModel
    @State private var showAddMeal = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Date navigation
                    DateNavigationView(dayViewModel: dayViewModel)
                    
                    // Calories card
                    CalorieCardView(vm: dayViewModel)
                    
                    // Streak
                    StreakView(streak: dayViewModel.streak)
                    
                    // Meals list
                    MealsListView(vm: dayViewModel)
                    
                    Spacer()
                    
                    Button {
                        showAddMeal = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Ajouter un repas")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .clipShape(Capsule())
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Calo")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: StatsView(vm: dayViewModel)) {
                        Image(systemName: "chart.bar.fill")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
               
            }
            .sheet(isPresented: $showAddMeal) {
                AddMealView(dayViewModelm: dayViewModel)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(vm: dayViewModel)
            }
        }
    }
}



// MARK: - Streak
struct StreakView: View {
    let streak: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Text(streak > 0 ? "🔥" : "💤")
                .font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text(streak > 0 ? "\(streak) jour\(streak > 1 ? "s" : "") dans l'objectif" : "Pas encore de streak")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(streak > 0 ? "Continuez comme ça !" : "Restez dans votre objectif aujourd'hui")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}


#Preview {
    HomeView(
        dayViewModel: DayViewModel(
            persistence: DayPersistenceModel(
                context: PersistenceController.shared.container
                    .viewContext)))
    
}
