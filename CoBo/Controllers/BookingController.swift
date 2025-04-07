//
//  BookingController.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import Foundation
import SwiftData

class BookingController {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllBooking() -> [Booking] {
        let descriptor = FetchDescriptor<Booking>()
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching bookings: \(error)")
            return []
        }
    }
}
