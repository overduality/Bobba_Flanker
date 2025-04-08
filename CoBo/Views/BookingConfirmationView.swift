//
//  BookingConfirmationView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 27/03/25.
//

import SwiftUI

struct BookingConfirmationView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var navigationPath: NavigationPath
    
    var bookingController = BookingController()
    var booking: Booking?
    
    var formattedBookingDate: String {
        guard let booking = booking else { return "" }
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        
        return "\(weekdayFormatter.string(from: booking.date)), \(dateFormatter.string(from: booking.date))"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image("booking-confirmation-icon")
                    .resizable()
                    .frame(width: 66.0, height: 66.0)
                    .padding(.bottom, 20)
                Text("Review Your Booking")
                    .font(.system(size: 21))
                    .bold()
                    .padding(.bottom, 6)
                Text("Please review your booking before confirming")
                    .font(.system(size: 13))
                    .padding(.bottom, 25)
                HStack {
                    Text("Date")
                        .font(.system(size: 14))
                    Spacer()
                    Text(formattedBookingDate).font(.system(size: 13, weight: .medium))
                }
                .padding(.top, 15)
                .padding(.bottom, 15)
                Divider()
                HStack {
                    Text("Time").font(.system(size: 14))
                    Spacer()
                    Text(booking?.timeslot.name ?? "").font(.system(size: 13, weight: .medium))
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                Divider()
                HStack {
                    Text("Space").font(.system(size: 14))
                    Spacer()
                    Text(booking?.collabSpace.name ?? "").font(.system(size: 13, weight: .medium))
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                Divider()
                HStack {
                    Text("Coordinator").font(.system(size: 14))
                    Spacer()
                    Text(booking?.coordinator?.name ?? "").font(.system(size: 13, weight: .medium))
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                Divider()
                HStack {
                    Text("Meeting Name").font(.system(size: 14))
                    Spacer()
                    Text(booking?.name ?? "").font(.system(size: 13, weight: .medium)).frame(maxWidth: .infinity, alignment: .trailing)                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                Divider()
                HStack {
                    Text("Purpose").font(.system(size: 14))
                    Spacer()
                    Text(booking?.purpose?.rawValue ?? "").font(.system(size: 13, weight: .medium))
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                Divider()
                HStack(alignment: .top) {
                    Text("Participants").font(.system(size: 14))
                    Spacer()
                    VStack(alignment: .trailing){
                        if booking?.participants.count ?? 0 == 0 {
                            Text("No participants inputted").font(.system(size: 13)).foregroundColor(.gray)
                        }else{
                            ForEach(booking?.participants ?? []) { participant in
                                Text(participant.name).font(.system(size: 13, weight: .medium))
                            }
                        }
                        
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                ZStack {
                    Button(action: {
                        confirmBooking()
                    }) {
                        Text("Confirm")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                Color("Purple")
                            )
                            .cornerRadius(24)
                            .padding(.horizontal, 12)
                            .padding(.top, 24)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .safeAreaPadding()
        .padding(16)
        .navigationTitle("Booking Confirmation")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: BookingSuccessContext.self) { context in
            // TODO: If the booking is auto checkin then it will show different success view. There is isAutoCheckIn in context
            BookingSuccessView(navigationPath: $navigationPath, booking: context.booking)
        }
        .onAppear() {
            bookingController.setupModelContext(modelContext)
        }
    }
    
    func confirmBooking() {
        guard let unwrappedBooking = booking else { return }
        
        let isAutoCheckIn = isAutoCheckInBooking(unwrappedBooking)
        
        if isAutoCheckIn {
            unwrappedBooking.status = .checkedIn
        }
        
        bookingController.addBooking(booking: unwrappedBooking)
        navigationPath.append(BookingSuccessContext(booking: unwrappedBooking, isAutoCheckIn: isAutoCheckIn))
    }
    
    func isAutoCheckInBooking(_ booking: Booking) -> Bool {
        let startCheckIn = booking.timeslot.startCheckIn
        let endCheckIn = booking.timeslot.endCheckIn
        let endTimeslot = doubleToTime(booking.timeslot.endHour)
        let date = booking.date
        let calendar = Calendar.current
        let now = Date()
        
        if !calendar.isDate(now, inSameDayAs: date) {
            return false
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if let startTime = formatter.date(from: startCheckIn),
           let endTime = formatter.date(from: endCheckIn), let endTimeslot = formatter.date(from: endTimeslot) {
            
            let startTimeComponents = calendar.dateComponents([.hour, .minute], from: startTime)
            let endTimeComponents = calendar.dateComponents([.hour, .minute], from: endTime)
            let endTimeslotTimeComponents = calendar.dateComponents([.hour, .minute], from: endTimeslot)
            
            var startDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            startDateComponents.hour = startTimeComponents.hour
            startDateComponents.minute = startTimeComponents.minute

            var endDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            endDateComponents.hour = endTimeComponents.hour
            endDateComponents.minute = endTimeComponents.minute
            
            var endTimeslotComponents = calendar.dateComponents([.year, .month, .day], from: date)
            endTimeslotComponents.hour = endTimeslotTimeComponents.hour
            endTimeslotComponents.minute = endTimeslotTimeComponents.minute
            
            if let startDate = calendar.date(from: startDateComponents),
               let endDate = calendar.date(from: endDateComponents),
               let endTimeslotDate = calendar.date(from: endTimeslotComponents) {
                if now >= startDate && now <= endDate {
                    return true
                }
                else if now >= endDate && now <= endTimeslotDate {
                    return true
                }
            }
        }
        
        return false
    }
    
    func doubleToTime(_ number: Double) -> String {
        let hour = Int(number.rounded(.towardZero))
        let minute = Int(number.truncatingRemainder(dividingBy: 1) * 60)
        
        let stringHour = hour < 10 ? "0\(hour)" : String(hour)
        let stringMinute = minute < 10 ? "0\(minute)" : String(minute)
        
        return "\(stringHour):\(stringMinute)"
    }
}

#Preview {
    let navigationPath = NavigationPath()
    let booking = DataManager.getBookingData().first!
    BookingConfirmationView(navigationPath: .constant(navigationPath), booking: booking)
}
