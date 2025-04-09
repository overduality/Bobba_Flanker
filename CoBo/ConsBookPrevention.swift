//
//  ConsBookPrevention.swift
//  CoBo
//
//  Created by Rieno on 07/04/25.
//

import Foundation

final class BookingValidator {
    static func isBookingValid(newBooking: Booking, existingBookings: [Booking]) -> Bool {
        guard let newCoordinator = newBooking.coordinator else {
            return false
        }

        let newStart = newBooking.timeslot.startHour
        let newEnd = newBooking.timeslot.endHour

        for booking in existingBookings {
            guard let existingCoordinator = booking.coordinator else {
                continue
            }

            if existingCoordinator.email == newCoordinator.email {
                let existingStart = booking.timeslot.startHour
                let existingEnd = booking.timeslot.endHour

                let isOverlapping = newStart < existingEnd && newEnd > existingStart
                let isConsecutive = newEnd == existingStart || newStart == existingEnd

                if isOverlapping || isConsecutive {
                    return false
                }
            }
        }

        return true
    }
}
