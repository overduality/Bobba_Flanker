//
//  PickDateView.swift
//  cobo-personal
//
//  Created by Amanda on 25/03/25.
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
            VStack {
                Text(formattedDate)
                    .font(.system(size: 11))
                    .foregroundColor(.white)
                
                Text(dayText)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(width:72, height: 49)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("Purple"),
                        Color("Medium-Purple")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(12)
            
        }
    
}

// Example Preview with a selected date
struct SelectedDateView_Previews: PreviewProvider {
    static var previews: some View {
            SelectedDateComponent(selectedDate: .constant(Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 26))!))
        }
}

