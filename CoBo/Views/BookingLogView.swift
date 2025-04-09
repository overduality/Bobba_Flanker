//
//  BookingLogView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import SwiftUI

struct BookingLogView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var selectedDate: Date = Date()
    @State private var navigationPath = NavigationPath()
    
    var bookingController = BookingController()
    
    @State var bookings: [Booking] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0){
                ZStack(alignment: .topLeading) {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.lightPurple.opacity(0.3)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 220)
                    .ignoresSafeArea()
                    VStack(alignment: .leading, spacing: 6) {
                        Text("🧾").font(.system(size: 34)).fontWeight(.bold)
                        Text("Booking Logs").font(.system(size: 21)).fontWeight(.bold)
                        Text("Search for reservation records here.").font(.system(size: 13))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                }
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16){
                        Text("Search by date 🔍").font(.system(size: 14)).fontWeight(.medium)
                        DateManager(selectedDate: $selectedDate)
                    }
                    VStack(alignment: .leading){
                        Text("Booking Logs").font(.system(size: 14)).fontWeight(.medium)
                        if(bookings.count == 0){
                            VStack {
                                Spacer()
                                VStack {
                                    Image("no-booking-found")
                                        .foregroundColor(.red)
                                        .font(.system(size: 40))
                                    Text("No bookings found").font(.system(size: 13)).foregroundColor(.gray).padding(.top, 4)
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        }else{
                            ScrollView {
                                VStack {
                                    ForEach(bookings) { booking in
                                        BookingLogCardComponent(booking: booking)
                                            .padding(.vertical)
                                            .onTapGesture { CGPoint in
                                                navigationPath.append(BookingLogDetailContext(booking: booking))
                                            }
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
                .safeAreaPadding()
                .padding(.horizontal, 16)
                .padding(.top, -54)
            }
            .navigationDestination(for: BookingLogDetailContext.self) { context in
                BookingLogDetailsView(navigationPath: $navigationPath, booking: context.booking)
            }
        }
        .onAppear() {
            bookingController.setupModelContext(modelContext)
            bookingController.autoCloseBooking()
            bookings = bookingController.getBookingsByDate(selectedDate)
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            bookings = bookingController.getBookingsByDate(newValue)
        }
    }
}

#Preview {
    BookingLogView()
}
