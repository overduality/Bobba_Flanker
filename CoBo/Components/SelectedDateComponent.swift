//
//  SelectedDate.swift
//  Core challenge 2 Stand Alone
//
//  Created by Rieno on 10/05/25.
//
import SwiftUI

struct SelectedDateComponent: View {
    @Binding var selectedDate: Date
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: selectedDate)
    }
    private var dayText: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(selectedDate) {
            return "Today"
        } else {
            let formatter = DateFormatter()
                        formatter.dateFormat = "E"
                        return formatter.string(from: selectedDate)
        }
    }
    var body: some View {
            HStack {
                Text(dayText + ",")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.trailing, -4)
                Text(formattedDate)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(width:170, height: 50)
            .background(Color("Green-Dark"))
            .cornerRadius(13)
            .padding(.horizontal, 32)
            .padding(.vertical,16)

        }
    
}

struct SelectedDateView_Previews: PreviewProvider {
    static var previews: some View {
            SelectedDateComponent(selectedDate: .constant(Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 10))!))
        }
}

