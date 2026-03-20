//
//  StatsView.swift
//  NutriDay
//
//  Created by Modibo on 14/03/2026.
//

import SwiftUI
import Charts

struct StatsView: View {
    @State var dayViewModel = DayViewModel()
    @State private var weekData: [(date: Date, calories: Double)] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Chart
                VStack(alignment: .leading, spacing: 12) {
                    Text("7 derniers jours")
                        .font(.headline)
                    
                    Chart {
                        ForEach(weekData, id: \.date) { item in
                            BarMark(
                                x: .value("Jour", item.date, unit: .day),
                                y: .value("Calories", item.calories)
                            )
                            .foregroundStyle(
                                item.calories <= dayViewModel.targetCalories ? Color.green : Color.red
                            )
                            .cornerRadius(6)
                        }
                        RuleMark(y: .value("Objectif", dayViewModel.targetCalories))
                            .foregroundStyle(.orange)
                            .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [5]))
                            .annotation(position: .top, alignment: .trailing) {
                                Text("Objectif")
                                    .font(.caption2)
                                    .foregroundStyle(.orange)
                            }
                    }
                    .frame(height: 220)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { value in
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                        }
                    }
                }
                .padding(20)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                
                // Streak card
                VStack(spacing: 8) {
                    Text("🔥")
                        .font(.system(size: 48))
                    Text("\(dayViewModel.currentStreak())")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(.orange)
                    Text("Jours consécutifs dans l'objectif")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Statistiques")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadWeekData() }
    }
    
    func loadWeekData() {
        weekData = dayViewModel.weekData()
    }
}
#Preview {
    StatsView()
}

