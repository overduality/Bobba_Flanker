//
//  TimeslotView.swift
//  cobo-personal
//
//  Created by Amanda on 25/03/25.
//

import SwiftUI

struct TimeslotComponent: View {
    @Binding var timeslot: Timeslot

    var body: some View {
        Button(action: {
            
        }) {
            Text("\(timeslot.name)")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color("Dark-Purple"))
                
                .frame(width:93, height: 36)
                .background(
                    Color.white
                )
                .cornerRadius(12)
                .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("Light-Purple"), lineWidth: 1)
                    )
        }
    }
  
}


#Preview {
//    // Create sample timeslots with specific times
    let timeslot = DataManager.getTimeslotsData()[0]
    TimeslotComponent(timeslot: .constant(timeslot))
//    let morningSlot = Timeslot(
//        startTime: Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!,
//        endTime: Calendar.current.date(from: DateComponents(hour: 10, minute: 0))!
//    )
//    
//    let afternoonSlot = Timeslot(
//        startTime: Calendar.current.date(from: DateComponents(hour: 14, minute: 0))!,
//        endTime: Calendar.current.date(from: DateComponents(hour: 15, minute: 30))!
//    )
//    
//    return VStack {
//        TimeslotComponent(timeslot: .constant(morningSlot))
//        TimeslotComponent(timeslot: .constant(afternoonSlot))
//    }
}
