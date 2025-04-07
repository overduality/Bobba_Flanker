//
//  UnselectedDateView.swift
//  cobo-personal
//
//  Created by Amanda on 25/03/25.
//
import SwiftUI

struct UnselectedDateComponent :View{
        @Binding var unselectedDate: Date
        private var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM"
            return formatter.string(from: unselectedDate)
        }
        private var dayText: String {
            let calendar = Calendar.current
            if calendar.isDateInToday(unselectedDate) {
                return "Today"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "E"
                return formatter.string(from: unselectedDate)
            }
        }
        var body: some View {
            
                VStack {
                    Text(formattedDate)
                        .font(.system(size: 11))
                        .foregroundColor(Color("Dark-Purple"))
                    
                    Text(dayText)
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .foregroundColor(Color("Dark-Purple"))
                }
                .padding()
                .frame(width:72, height: 49)
                .background(
                    Color(.white)
                    )
                
                .cornerRadius(12)
                .overlay(
                        RoundedRectangle(cornerRadius: 12) 
                            .stroke(Color("Light-Purple"), lineWidth: 1) 
                    )
                
            
        }
    }
    

struct UnselectedDateView_Previews: PreviewProvider {
    static var previews: some View {
        UnselectedDateComponent(unselectedDate: .constant(Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 26))!))
    }
}
