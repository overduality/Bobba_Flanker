//
//  QRCode.swift
//  Project 1 Apple
//
//  Created by Rieno on 27/03/25.
//

import SwiftUI

func generateICS() -> String {
    let eventTitle = "Meeting Name (*)"
    let eventDescription = "Code (*)"
    let eventLocation = "Meeting Location"
    let organizerEmail = "emmanuelbobba3@gmail.com"
    let attendeeEmail = "lokajaya41D4@gmail.com"

    let startDate = "20250327T051800Z" // UTC format
    let endDate = "20250327T052300Z"   // 5 minutes later

    return """
    BEGIN:VCALENDAR
    VERSION:2.0
    PRODID:-//CustomApp//NONSGML v1.0//EN
    BEGIN:VEVENT
    UID:550e8400-e29b-41d4-a716-446655440000
    DTSTART:\(startDate)
    DTEND:\(endDate)
    SUMMARY:\(eventTitle)
    DESCRIPTION:\(eventDescription)
    LOCATION:\(eventLocation)
    ORGANIZER;CN=Emmanuel Rieno:mailto:\(organizerEmail)
    ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=Evan Lokajaya:mailto:\(attendeeEmail)
    
    BEGIN:VALARM
    ACTION:DISPLAY
    DESCRIPTION:Reminder for Meeting
    TRIGGER:-PT15M
    END:VALARM
    
    BEGIN:VALARM
    ACTION:DISPLAY
    DESCRIPTION:Follow Up for Check-In
    TRIGGER:PT5M
    END:VALARM

    END:VEVENT
    END:VCALENDAR
    """
}



