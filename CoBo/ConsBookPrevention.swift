//
//  ConsBookPrevention.swift
//  CoBo
//
//  Created by Rieno on 07/04/25.
//

import Foundation

final class BookingValidator {
    
    static func isBookingValid(newBooking: Booking, existingBookings: [Booking]) -> Bool {
        // new booking's time range
        let newStart = newBooking.timeslot.startHour
        let newEnd = newBooking.timeslot.endHour
        
        // safely unwrap newBooking.coordinator
        guard let newCoordinator = newBooking.coordinator else {
            return false
        }

        // check for consecutive bookings using loop
        for booking in existingBookings {
            guard let existingCoordinator = booking.coordinator else {
                continue // skip this booking if coordinator is missing
            }

            if existingCoordinator.email == newCoordinator.email {
                let existingStart = booking.timeslot.startHour
                let existingEnd = booking.timeslot.endHour

                let isConsecutiveBefore = newEnd == existingStart
                let isConsecutiveAfter = newStart == existingEnd

                if isConsecutiveBefore || isConsecutiveAfter {
                    return false
                }
            }
        }
        
        return true
    }
}
