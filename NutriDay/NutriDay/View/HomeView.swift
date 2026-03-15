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
     var vm: DayViewModel
    @State private var showAddMeal = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Date navigation
                    DateNavigationView(dayViewModel: vm)

                    // Calories card
                    CalorieCardView(vm: vm)

                    // Streak
                    StreakView(streak: vm.streak)

                    // Meals list
                    MealsListView(vm: vm)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Calo")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: StatsView(vm: vm)) {
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
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showAddMeal = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Ajouter un repas")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .clipShape(Capsule())
                    }
                }
            }
            .sheet(isPresented: $showAddMeal) {
                AddMealView(vm: vm)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(vm: vm)
            }
        }
    }
}

// MARK: - Date Navigation
struct DateNavigationView: View {
    var dayViewModel: DayViewModel

    var isToday: Bool {
        Calendar.current.isDateInToday(dayViewModel.selectedDate)
    }

    var formattedDate: String {
        if Calendar.current.isDateInToday(dayViewModel.selectedDate) { return "Aujourd'hui" }
        if Calendar.current.isDateInYesterday(dayViewModel.selectedDate) { return "Hier" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d MMM"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: dayViewModel.selectedDate)
    }

    var body: some View {
        HStack {
            Button {
                dayViewModel.changeDay(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            }

            Spacer()

            Text(formattedDate)
                .font(.headline)
                .fontWeight(.semibold)

            Spacer()

            Button {
                dayViewModel.changeDay(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .fontWeight(.semibold)
                    .foregroundStyle(isToday ? .gray : .green)
            }
            .disabled(isToday)
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Calorie Card
struct CalorieCardView: View {
     var vm: DayViewModel

    var statusColor: Color {
        if vm.progress < 0.75 { return .green }
        if vm.progress < 1.0 { return .orange }
        return .red
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Calories")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("\(Int(vm.totalCalories))")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(statusColor)
                        Text("/ \(Int(vm.targetCalories)) kcal")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Restant")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(Int(max(vm.targetCalories - vm.totalCalories, 0))) kcal")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(statusColor)
                }
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                        .frame(height: 12)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(statusColor)
                        .frame(width: geo.size.width * vm.progress, height: 12)
                        .animation(.spring(), value: vm.progress)
                }
            }
            .frame(height: 12)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
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

// MARK: - Meals List
struct MealsListView: View {
     var vm: DayViewModel

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
    HomeView(
vm: DayViewModel(
    persistence: DayPersistenceModel(
        context: PersistenceController.shared.container
            .viewContext)))
    
}
