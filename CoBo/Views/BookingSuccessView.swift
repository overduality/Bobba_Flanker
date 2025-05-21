//
//  BookingSuccessView.swift
//  CoBo
//
//  Created by Rieno on 27/03/25.
//  Adjusted by Rieno on 07/05/25
import SwiftUI

struct BookingSuccessView: View {
    @Binding var navigationPath: NavigationPath
    @Binding var booking: Booking?
    @Environment(\.dismiss) private var dismiss
    @Environment(Settings.self) private var settings
    @State private var shadowRadius: CGFloat = 5
    @State private var isPresented = false
    
    // MARK: - Computed Properties
    
    var formattedBookingDate: String {
        guard let date = booking?.date else { return "Unknown Date" }
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        
        return "\(weekdayFormatter.string(from: date)), \(dateFormatter.string(from: date))"
    }
    
    var startCheckIn: String {
        guard let timeslot = booking?.timeslot else { return "???" }
        return TimeslotUtil.getStartCheckInTime(timeslot: timeslot, tolerance: settings.checkInTolerance)
    }
    
    var endCheckIn: String {
        guard let timeslot = booking?.timeslot else { return "???" }
        return TimeslotUtil.getEndCheckInTime(timeslot: timeslot, tolerance: settings.checkInTolerance)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                    navigationPath = NavigationPath()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("Green-Dark"))
                }
                
            }
            
            ZStack {
                Circle()
                    .fill(Color("Green-Dark"))
                    .frame(width: 86, height: 86)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 37, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.top, -10)
            
            Text("Success!")
                .font(.system(size: 40, weight: .regular))
                .padding(.bottom, 10)
            
            VStack(spacing: 15) {
                (
                    Text("The check-in code is ")
                        .font(.system(size:16)) +
                    Text("required")
                        .font(.system(size:16))
                        .fontWeight(.bold) +
                    Text(" to check in")
                        .font(.system(size:16))
                )
                
                CodeDisplayComponent(code: booking?.checkInCode ?? "XXXXXX")
                
            }
            .padding(.vertical, 20)
            
            VStack(spacing: 8) {
                HStack{Text("The check-in window will remain open for 30 minutes")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Text("(\(startCheckIn) - \(endCheckIn))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
                Text("Late check-ins will be marked as no-shows, and the booked space will be reopened.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
                
                // Wrap the divider and QR section in a gray box
                VStack(spacing: 16) {

                    
                    if let safeBooking = booking {
                        CalendarQRView(booking: safeBooking)
                    } else {
                        Text("QR code unavailable.")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
            }
            .frame(width: 750)
            .background(Color.white)
            .cornerRadius(15)
        }
    }
}


