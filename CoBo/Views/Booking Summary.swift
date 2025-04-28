//
//  Booking Summary.swift
//  CoBo
//
//  Created by Rieno on 07/04/25.
//

import SwiftUI

struct Booking_Summary: View {
    @Environment(Settings.self) private var settings
    
    var booking: Booking
    @State var collabSpace: CollabSpace?
    
    var formattedBookingDate: String {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        
        return "\(weekdayFormatter.string(from: booking.date)), \(dateFormatter.string(from: booking.date))"
    }
    
    var startCheckIn: String {
        get {
            return TimeslotUtil.getStartCheckInTime(timeslot: booking.timeslot, tolerance: settings.checkInTolerance)
        }
    }
    
    var endCheckIn: String {
        get {
            return TimeslotUtil.getEndCheckInTime(timeslot: booking.timeslot, tolerance: settings.checkInTolerance)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Date")
                    .font(.system(.callout))
                Spacer()
                Text(formattedBookingDate)
                    .bold()
                    .font(.system(.callout))
            }
            
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Meeting Time")
                    .font(.system(.callout))
                Spacer()
                Text("\(booking.timeslot.doubleToTime(booking.timeslot.startHour))- \(booking.timeslot.doubleToTime(booking.timeslot.endHour))")
                    .bold()
                    .font(.system(.callout))
            }
            
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Check-In Time")
                    .font(.system(.callout))
                Spacer()
                Text("\(startCheckIn) - \(endCheckIn)")
                    .bold()
                    .font(.system(.callout))
            }
            
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Space")
                    .font(.system(.callout))
                Spacer()
                Text(booking.collabSpace.name)
                    .bold()
                    .font(.system(.callout))
            }
            
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Coordinator")
                    .font(.system(.callout))
                Spacer()
                Text(booking.coordinator?.name ?? "N/A")
                    .bold()
                    .font(.system(.callout))
            }
            
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Meeting Name")
                    .font(.system(.callout))
                Spacer()
                Text(booking.name ?? "Untitled")
                    .bold()
                    .font(.system(.callout))
            }
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Purpose")
                    .font(.system(.callout))
                Spacer()
                Text(booking.purpose?.rawValue ?? "")
                    .bold()
                    .font(.system(.callout))
            }
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Participants")
                    .font(.system(.callout))
                Spacer()
                if(booking.participants.count == 0) {
                    Text("No participants inputted").font(.callout).foregroundColor(.gray)
                }else{
                    VStack(alignment: .trailing){
                        ForEach(booking.participants) { participant in
                            Text(participant.name).font(.system(.callout, weight: .medium))
                        }
                        
                    }
                }
                
            }
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
        }
        
    }
}


#Preview {
    let sampleBooking = DataManager.getBookingData().first! // make sure this exists
    Booking_Summary(booking: sampleBooking)
}
