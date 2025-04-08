//
//  QRCode.swift
//  Project 1 Apple
//
//  Created by Rieno on 25/03/25.
//

import SwiftUI
import UIKit
import CoreImage.CIFilterBuiltins


func generateQRCodeFromBooking(_ booking: Booking) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Jakarta")
    let calendar = Calendar(identifier: .gregorian)
    
    var startComponents = calendar.dateComponents([.year, .month, .day], from: booking.date)
    startComponents.hour = Int(booking.timeslot.startHour)
    startComponents.minute = Int((booking.timeslot.startHour.truncatingRemainder(dividingBy: 1)) * 60)
    let startDate = calendar.date(from: startComponents)!

    var endComponents = calendar.dateComponents([.year, .month, .day], from: booking.date)
    endComponents.hour = Int(booking.timeslot.endHour)
    endComponents.minute = Int((booking.timeslot.endHour.truncatingRemainder(dividingBy: 1)) * 60)
    let endDate = calendar.date(from: endComponents)!

    let startDateStr = dateFormatter.string(from: startDate)
    let endDateStr = dateFormatter.string(from: endDate)

    let meetingName = booking.name ?? "Meeting"
    let meetingDescription = "Check-in Code: \(booking.checkInCode ?? ""). Be present at \(booking.collabSpace.name)"
    let organizerName = booking.coordinator?.name ?? ""
    let organizerEmail = booking.coordinator?.email ?? "unknown@email.com"

    let attendees = booking.participants.map { participant in
        """
        ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=\(participant.name):mailto:\(participant.email)
        """
    }.joined(separator: "\n")

    return """
    BEGIN:VCALENDAR
    VERSION:2.0
    PRODID:-//hacksw/handcal//NONSGML v1.0//EN
    BEGIN:VEVENT
    UID:\(UUID().uuidString)
    DTSTAMP:\(startDateStr)
    DTSTART:\(startDateStr)
    DTEND:\(endDateStr)
    SUMMARY:\(meetingName)
    DESCRIPTION:\(meetingDescription)
    ORGANIZER;CN=\(organizerName):mailto:\(organizerEmail)
    \(attendees)
    BEGIN:VALARM
    ACTION:DISPLAY
    DESCRIPTION:Reminder for \(meetingName)
    TRIGGER:-PT15M
    END:VALARM
    BEGIN:VALARM
    ACTION:DISPLAY
    DESCRIPTION:Follow-up for \(meetingName)
    TRIGGER;RELATED=END:PT60M
    END:VALARM
    END:VEVENT
    END:VCALENDAR
    """
}


func generateQRCode(from string: String) -> UIImage? {
    print("Generating QR Code for: \(string.prefix(50))...")
    
    let data = string.data(using: .utf8)
    let filter = CIFilter.qrCodeGenerator()
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("M", forKey: "inputCorrectionLevel")

    if let outputImage = filter.outputImage {
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = outputImage.transformed(by: transform)
        
        let context = CIContext()
        if let cgImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) {
            return UIImage(cgImage: cgImage)
        }
    }

    print("Failed to generate QR Code")
    return nil
}
    
