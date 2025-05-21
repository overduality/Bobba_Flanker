//
//  BookingLogCardComponent.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import SwiftUI

struct BookingLogCardComponent: View {
    var booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(booking.name ?? "")
                .font(.system(size: 14))
                .bold()
                .padding(.bottom, 8)
            Divider()
            
            HStack {
                Text("Place:")
                    .font(.system(size: 12))
                Text(booking.collabSpace.name)
                    .font(.system(size: 12))
                    .bold()
            }
            
            HStack {
                Text("Coordinator:")
                    .font(.system(size: 12))
                Text(booking.coordinator?.name ?? "No Coordinator")
                    .font(.system(size: 12))
            }
            
            HStack {
                Text("Purpose:")
                    .font(.system(size: 12))
                Text(booking.purpose?.rawValue ?? "")
                    .font(.system(size: 12))
            }
            
            HStack {
                Text("Timeslot:")
                    .font(.system(size: 12))
            }
            
            HStack {
                Text(booking.timeslot.name)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color("Dark-Purple"))
                    .frame(width:93, height: 36)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("Light-Purple"), lineWidth: 1)
                    )
                
                Spacer()
                
                BookingStatusComponent(status: booking.status)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    let booking = DataManager.getBookingData().first!
    BookingLogCardComponent(booking: booking)
        .padding()
        .background(Color.gray.opacity(0.1))
}
