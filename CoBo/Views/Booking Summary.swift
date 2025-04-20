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
            print(settings.checkInTolerance)
            return TimeslotUtil.getStartCheckInTime(timeslot: booking.timeslot, tolerance: settings.checkInTolerance)
        }
    }
    
    var endCheckIn: String {
        get {
            print(settings.checkInTolerance)
            return TimeslotUtil.getEndCheckInTime(timeslot: booking.timeslot, tolerance: settings.checkInTolerance)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Date")
                    .font(.system(size: 14))
                Spacer()
                Text(formattedBookingDate)
                    .bold()
                    .font(.system(size: 14))
            }
            
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Check-In Time")
                    .font(.system(size: 14))
                Spacer()
                Text("\(startCheckIn) - \(endCheckIn)")
                    .bold()
                    .font(.system(size: 14))
            }
            
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Space")
                    .font(.system(size: 14))
                Spacer()
                Text(booking.collabSpace.name)
                    .bold()
                    .font(.system(size: 14))
            }
            
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Coordinator")
                    .font(.system(size: 14))
                Spacer()
                Text(booking.coordinator?.name ?? "N/A")
                    .bold()
                    .font(.system(size: 14))
            }
            
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Meeting Name")
                    .font(.system(size: 14))
                Spacer()
                Text(booking.name ?? "Untitled")
                    .bold()
                    .font(.system(size: 14))
            }
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Purpose")
                    .font(.system(size: 14))
                Spacer()
                Text(booking.purpose?.rawValue ?? "")
                    .bold()
                    .font(.system(size: 14))
            }
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
            HStack {
                Text("Participants")
                    .font(.system(size: 14))
                Spacer()
                if(booking.participants.count == 0) {
                    Text("No participants inputted").font(.system(size: 13)).foregroundColor(.gray)
                }else{
                    VStack(alignment: .trailing){
                        ForEach(booking.participants) { participant in
                            Text(participant.name).font(.system(size: 13, weight: .medium))
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
