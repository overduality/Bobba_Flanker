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
    
    
    
}
