//
//  BookingStatus.swift
//  CoBo
//
//  Created by Evan Lokajaya on 25/03/25.
//

import Foundation

// TODO: Better case naming for BookingStatus
enum BookingStatus: String, Codable, Equatable, CaseIterable, Identifiable{
    case checkedIn = "Checked In"
    case notCheckedIn = "Not Checked In"
    case closed = "Closed"
    case canceled = "Canceled"
    
    var id: String { self.rawValue }
}
