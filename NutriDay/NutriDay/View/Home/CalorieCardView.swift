//
//  CalorieCardView.swift
//  NutriDay
//
//  Created by Modibo on 15/03/2026.
//

import SwiftUI

// MARK: - Calorie Card
struct CalorieCardView: View {
    var dayViewModel: DayViewModel
    
    var statusColor: Color {
        if dayViewModel.progress < 0.75 { return .green }
        if dayViewModel.progress < 1.0 { return .orange }
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
                        Text("\(Int(dayViewModel.totalCalories))")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(statusColor)
                        Text("/ \(Int(dayViewModel.targetCalories)) kcal")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Restant")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(Int(max(dayViewModel.targetCalories - dayViewModel.totalCalories, 0))) kcal")
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
                        .frame(width: geo.size.width * dayViewModel.progress, height: 12)
                        .animation(.spring(), value: dayViewModel.progress)
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
    CalorieCardView()
}
