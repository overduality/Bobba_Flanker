//
//  DateManager.swift
//  cobo-personal
//
//  Created by Amanda on 25/03/25.
//  Adjusted by Rieno on 07/05/25
import SwiftUI

struct DateManager: View {
    @Environment(Settings.self) private var settings
    
    @Binding var selectedDate: Date
    var dates: [Date] {
        generateWeekdays()
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(dates, id: \.self) { date in
                    Button(action: {
                        selectedDate = date
                    }) {
                        if isSameDay(date1: date, date2: selectedDate) {
                            SelectedDateComponent(selectedDate: $selectedDate)
                        } else {
                            UnselectedDateComponent(unselectedDate: .constant(date))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    func generateWeekdays() -> [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        var currentDate = Date()
        
        // 6 weekdays
        while dates.count < 6 {
            let weekday = calendar.component(.weekday, from: currentDate)
            // no weekend
            if weekday >= 2 && weekday <= 6 {
                dates.append(currentDate)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        }
        
        return dates
    }
}

#Preview {
    DateManager(selectedDate: .constant(Date()))
    
}
