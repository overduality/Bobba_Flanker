//
//  SortBooking.swift
//  CoBo
//
//  Created by Rieno on 19/04/25.
//

import Foundation

struct SortBooking {
    static func sortBookings(_ bookings: [Booking]) -> [Booking] {
        let now = Date()

        let statusPriority: [BookingStatus: Int] = [
            .notCheckedIn: 0,
            .checkedIn: 1,
            .canceled: 2
        ]
        // Prioritas: Status > nearest timeslot or current timeslot > future booking sorted to the
        // earliest to the latest (same day)
       
        return bookings.sorted { a, b in
            // 1. Prioritize by status
            let aStatus = statusPriority[a.status] ?? 99
            let bStatus = statusPriority[b.status] ?? 99
            
            if aStatus != bStatus {
                return aStatus < bStatus
            }
            let aDateTime = combineDateWithTime(a.date, a.timeslot.startHour)
            let bDateTime = combineDateWithTime(b.date, b.timeslot.startHour)
            let aIsFuture = aDateTime >= now
            let bIsFuture = bDateTime >= now
            
            switch (aIsFuture, bIsFuture) {
            case (true, false):
                return true
            case (false, true):
                return false
            default:
                return aDateTime < bDateTime
            }
        }
    }

    private static func combineDateWithTime(_ date: Date, _ hour: Double) -> Date {
        var calendar = Calendar.current
        
        calendar.timeZone = TimeZone.current
        let hourPart = Int(hour)
        let minutePart = Int((hour - Double(hourPart)) * 60)
        
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = hourPart
        components.minute = minutePart
        
        return calendar.date(from: components) ?? date
    }
}
