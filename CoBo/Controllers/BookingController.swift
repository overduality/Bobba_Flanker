//
//  BookingController.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import Foundation
import SwiftData

class BookingController {
    var modelContext: ModelContext?
    
    func setupModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllBooking() -> [Booking] {
        guard let context = modelContext else {
            print("Model Context is Not Available : Get All Bookings")
            return []
        }
        
        let descriptor = FetchDescriptor<Booking>()
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching bookings: \(error)")
            return []
        }
    }
    
    func getBookingsByDate(_ date: Date) -> [Booking]{
        guard let context = modelContext else {
            print("Model Context is Not Available : Get Bookings By Date")
            return []
        }
        
        let calendar = Calendar.current
        
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<Booking> { booking in
            booking.date >= startOfDay && booking.date < endOfDay
        }
        var descriptor = FetchDescriptor<Booking>()
        descriptor.predicate = predicate
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching bookings by date: \(error)")
            return []
            }
    }
    
    func addBooking(booking: Booking) {
        guard let context = modelContext else {
            print("Model Context is Not Available : Add Booking")
            return
        }
        
        do {
            context.insert(booking)
            try context.save()
        } catch {
            print("Error adding booking: \(error)")
        }
    }
    
    func checkInBooking(_ checkInCode: String) -> [String]? {
        guard let context = modelContext else {
            print("Model Context is Not Available")
            return nil
        }
        
        let descriptor = FetchDescriptor<Booking>(
            predicate: #Predicate { $0.checkInCode == checkInCode }
        )
        
            do {
                let bookingFetched : Booking? = try context.fetch(descriptor).first
                guard let bookingFetched = bookingFetched else { return ["Not Found", "Please check your check-in code and try again."]}
                
                let bookingStatus = bookingFetched.getStatus()
                print("Booking Status: \(bookingStatus)")
                if(bookingStatus == "checkedIn"){
                    return ["You have already checked-in.", "Please contact the administrator for any issues."]
                }
                if(bookingStatus == "canceled"){
                    return ["This booking has been canceled.", "Please contact the administrator for any issues."]
                }
                // check
                let startCheckIn = bookingFetched.timeslot.startCheckIn
                let endCheckIn = bookingFetched.timeslot.endCheckIn
                let date = bookingFetched.date
                let calendar = Calendar.current
                let now = Date()
                
                if calendar.isDate(now, inSameDayAs: date) {
                    // date same as today
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    if let startTime = formatter.date(from: startCheckIn),
                       let endTime = formatter.date(from: endCheckIn) {
                        
                        let startTimeComponents = calendar.dateComponents([.hour, .minute], from: startTime)
                        let endTimeComponents = calendar.dateComponents([.hour, .minute], from: endTime)

                        var startDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                        startDateComponents.hour = startTimeComponents.hour
                        startDateComponents.minute = startTimeComponents.minute

                        var endDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                        endDateComponents.hour = endTimeComponents.hour
                        endDateComponents.minute = endTimeComponents.minute

                        if let startDate = calendar.date(from: startDateComponents),
                           let endDate = calendar.date(from: endDateComponents) {
                            if now >= startDate && now <= endDate {
                                bookingFetched.status = BookingStatus.checkedIn
                                try context.save()
                                return ["Check-in successful ✅", "You can now check into your collabspace."]
                            } else {
                                return notifyUserAboutCheckInTime(bookingFetched: bookingFetched)
                            }
                        }
                    }
                }else{
                    return notifyUserAboutCheckInTime(bookingFetched: bookingFetched)
                }

                
            } catch {
                print("Failed to fetch booking: \(error)")
                return nil
            }
        return nil
            
        }
    
    // FOR CASE NOT WITHIN CHECK-IN TIME
    func notifyUserAboutCheckInTime(bookingFetched: Booking) -> [String]{
        // format date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let formattedDate = formatter.string(from: bookingFetched.date)
        
        return ["Not within check-in time ⏳", "You can check-in for your booking at \(bookingFetched.collabSpace.name) on \(formattedDate), at \(bookingFetched.timeslot.startCheckIn) - \(bookingFetched.timeslot.endCheckIn)."]
    }
    
    
    
}
