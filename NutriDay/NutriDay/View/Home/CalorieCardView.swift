//
//  CalorieCardView.swift
//  NutriDay
//
//  Created by Modibo on 15/03/2026.
//

import SwiftUI
 import CoreData

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


#Preview {
    CalorieCardView(
        vm: DayViewModel(
            persistence: DayPersistenceModel(
                context: PersistenceController.shared
                    .container.viewContext)
        )
    )
}
