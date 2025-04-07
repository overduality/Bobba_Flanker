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
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func setupModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllBooking() -> [Booking] {
        guard let context = modelContext else {
            print("Model Context is Not Available")
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
    
    func getBookingByDate(_ date: Date) -> [Booking]{
        return []
    }
    
    
    
    
}
