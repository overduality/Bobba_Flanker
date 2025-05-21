//
//  Timeslot.swift
//  CoBo
//
//  Created by Evan Lokajaya on 25/03/25.
//  Adjusted by Rieno on 07/05/25

import Foundation
import SwiftData

@Model
class Timeslot: Hashable {
    var startHour: Double
    var endHour: Double

    var name: String {
        return "\(doubleToTime(startHour)) - \(doubleToTime(endHour))"
    }

    var startCheckIn: String {
        return doubleToTime(startHour - 0.25)
    }

    var endCheckIn: String {
        return doubleToTime(startHour + 0.25)
    }

    init(startHour: Double, endHour: Double) {
        self.startHour = startHour
        self.endHour = endHour
    }

    func doubleToTime(_ number: Double) -> String {
        let hour = Int(number.rounded(.towardZero))
        let minute = Int(number.truncatingRemainder(dividingBy: 1) * 60)

        let stringHour = hour < 10 ? "0\(hour)" : String(hour)
        let stringMinute = minute < 10 ? "0\(minute)" : String(minute)

        return "\(stringHour):\(stringMinute)"
    }

    // ✅ Add these:
    static func == (lhs: Timeslot, rhs: Timeslot) -> Bool {
        lhs.startHour == rhs.startHour && lhs.endHour == rhs.endHour
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(startHour)
        hasher.combine(endHour)
    }
}
