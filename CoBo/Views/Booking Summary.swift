//
//  Booking Summary.swift
//  CoBo
//
//  Created by Rieno on 07/04/25.
//

import SwiftUI

struct Booking_Summary: View {
    @State var booking: Booking
    @State var collabSpace: CollabSpace?
    var formattedBookingDate: String {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        
        return "\(weekdayFormatter.string(from: booking.date)), \(dateFormatter.string(from: booking.date))"
    }
    var body: some View {
        VStack{
            HStack {
                Text("Date")
                    .font(.system(size: 14))
                
                Spacer()
                Text(formattedBookingDate)
                    .bold()
                    .font(.system(size: 14))
            }
            Divider()
                .padding(.horizontal, 20)
                .background(.black)
            HStack {
                Text("Check-In Time")
                    .font(.system(size: 14))
                Spacer()
                Text("\(booking.timeslot.startCheckIn)  - \(booking.timeslot.endCheckIn)")
                    .bold()
                    .font(.system(size: 14))
                
            }
            Divider()
                .padding(.horizontal, 20)
                .background(.black)
            HStack {
                Text("Space")
                    .font(.system(size: 14))
                Spacer()
                Text(booking.collabSpace.name)
                    .bold()
                    .font(.system(size: 14))
            }
            Divider()
                .padding(.horizontal, 20)
                .background(.black)
            HStack {
                Text("Coordinator")
                    .font(.system(size: 14))
                Spacer()
                Text(booking.coordinator.name)
                    .bold()
                    .font(.system(size: 14))
            }

        }
    }}
#Preview {
    let sampleBooking = DataManager.getBookingData().first! // or create a mock
    Booking_Summary(booking: sampleBooking)
}

