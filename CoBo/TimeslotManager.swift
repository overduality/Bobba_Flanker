//
//  TimeslotManager.swift
//  cobo-personal
//
//  Created by Amanda on 25/03/25.
//

import SwiftUI
struct TimeslotManager : View{
//    @Binding var collabSpace: CollabSpace?
//    @Binding var selectedDate: Date?
//    @State var timeSlotActive:[T]
    @State var timeslots: [Timeslot] = DataManager.getTimeslotsData()
    
    var body: some View{
        let columns = [GridItem(.flexible(), spacing: 2),
                       GridItem(.flexible(), spacing: 2),
                       GridItem(.flexible(), spacing: 2)]
           LazyVGrid(columns: columns, spacing: 12) {
               ForEach(timeslots.prefix(6), id: \.self) { timeslot in
                   TimeslotComponent(timeslot: .constant(timeslot))
               }
           }
    }
}

#Preview {
    TimeslotManager()
}
