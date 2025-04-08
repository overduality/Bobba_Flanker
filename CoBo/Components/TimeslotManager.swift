//
//  TimeslotManager.swift
//  cobo-personal
//
//  Created by Amanda on 25/03/25.
//

import SwiftUI
struct TimeslotManager : View{
    @Environment(\.modelContext) var modelContext
    
    @Binding var navigationPath: NavigationPath
    @Binding var collabSpace: CollabSpace?
    @Binding var selectedDate: Date?
    
    var timeslotController = TimeslotController()
    @State var timeslots: [Timeslot] = []
    
    var body: some View{
        let availableTimeslots = getAvailableTimeslots()
        let columns = [GridItem(.flexible(), spacing: 2),
                       GridItem(.flexible(), spacing: 2),
                       GridItem(.flexible(), spacing: 2)]
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(availableTimeslots.prefix(6), id: \.self) { timeslot in
                let isBooked = getTimeslotStatus(timeslot: timeslot)
                TimeslotComponent(navigationPath: $navigationPath, timeslot: .constant(timeslot), isBooked: .constant(isBooked), selectedDate: selectedDate!, collabSpace: .constant(collabSpace!))
            }
        }
        .onAppear() {
            timeslotController.setupModelContext(modelContext)
            timeslots = timeslotController.getAllTimeslot()
        }
    }
    private func getAvailableTimeslots() -> [Timeslot] {
        guard let selectedDate = selectedDate else { return timeslots }
        
        return timeslots
    }
    private func getTimeslotStatus(timeslot: Timeslot) -> Bool {
        var bookingController = BookingController()
        bookingController.setupModelContext(modelContext)
        let bookings: [Booking] = bookingController.getAllBooking()
        let calendar = Calendar.current
        
        guard let selectedDate = selectedDate, let collabSpace = collabSpace else {
            return false
        }
        
        let today = Date()
        let currentTime = getCurrentHour()
        
        if timeslot.endHour < currentTime && isSameDay(date1: today, date2: selectedDate)  {
            return true
        }
        
        let selectedDay = calendar.startOfDay(for: selectedDate)
        
        return bookings.contains { booking in
            let bookingDay = calendar.startOfDay(for: booking.date)
            return isSameDay(date1: booking.date, date2: selectedDate) &&
            isSameCollabSpace(collabSpace1: booking.collabSpace, collabSpace2: collabSpace) && isSameTimeslot(timeslot1: booking.timeslot, timeslot2: timeslot)
        }
    }
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func isSameCollabSpace(collabSpace1: CollabSpace, collabSpace2: CollabSpace)->Bool{
        if(collabSpace1.name == collabSpace2.name){
            return true
        }
        return false
    }
    func isSameTimeslot(timeslot1: Timeslot, timeslot2: Timeslot)->Bool{
        if(timeslot1.endHour == timeslot2.endHour){
            return true
        }
        return false
    }

    private func getCurrentHour() -> Double {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let hour = Double(components.hour ?? 0)
        let minute = Double(components.minute ?? 0) / 60.0
        return hour + minute
    }
}

#Preview {
}
