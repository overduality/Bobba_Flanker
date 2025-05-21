//
//  UnselectedDate.swift
//  Core challenge 2 Stand Alone
//
//  Created by Rieno on 10/05/25.
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
//    Text("Tue, 30 Apr")
//        .font(.system(size: 16, weight: .semibold, design:.default))
//        .foregroundColor(buttonColor)
//    RoundedRectangle(cornerSize: .init(width: 13, height: 13))
//        .foregroundColor(.white)
//        .frame(width: 170, height: 50)
//        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 8)
        var body: some View {
            
            HStack {
                Text(dayText + ",")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Green-Dark"))
                    .padding(.trailing, -4)
                Text(formattedDate)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Green-Dark"))
            }
            .frame(width:170, height: 50)
            .background(
                Color(.white)
            )
            .cornerRadius(13)
            .shadow(color: Color.gray.opacity(0.25), radius: 4, x: 0, y: 8)
//            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 8)
            .padding(.horizontal, 20)
            .padding(.vertical,16)


            
        }
    }
    

struct UnselectedDateView_Previews: PreviewProvider {
    static var previews: some View {
        UnselectedDateComponent(unselectedDate: .constant(Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 10))!))
    }
}
