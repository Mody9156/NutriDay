//
//  DateNavigationView.swift
//  NutriDay
//
//  Created by Modibo on 15/03/2026.
//

import SwiftUI

// MARK: - Date Navigation
struct DateNavigationView: View {
    var dayViewModel = DayViewModel()
    
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

#Preview {
    DateNavigationView()
}
