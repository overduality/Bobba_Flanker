//
//  AdminBookingLogView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 21/04/25.
//

import SwiftUI

struct AdminBookingLogView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(Settings.self) private var settings
    
    @Binding var navigationPath: NavigationPath
    @State var showFilterSheet = false
    @State var bookings: [Booking] = []
    @State var filterPredicate = FilterPredicate()
    
    var bookingController = BookingController()
    @State private var isLoading: Bool = false
    
    var body: some View {
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
                    Button {
                        showFilterSheet.toggle()
                    } label: {
                        Text("Filter")
                            .font(.system(size: 13))
                    }

                }
                .padding(.horizontal, 24)
                .padding(.top, 28)
            }
            .frame(height: 220)
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading){
                    Text("Booking Logs").font(.system(size: 14)).fontWeight(.medium)
                    if isLoading {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(0..<3, id: \.self) { _ in
                                    BookingLogSkeletonCard()
                                }
                            }
                            .padding(.vertical)
                        }
                    } else if (bookings.count == 0){
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
                        
                    } else {
                        ScrollView {
                            VStack {
                                ForEach(bookings) { booking in
                                    BookingLogCardComponent(booking: booking)
                                        .padding(.vertical)
                                        .onTapGesture {
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
        }
        .navigationDestination(for: BookingLogDetailContext.self) { context in
            BookingLogDetailsView(navigationPath: $navigationPath, booking: context.booking)
        
        }
        .onAppear() {
            bookingController.setupModelContext(modelContext)
            bookingController.autoCloseBooking(appSettings: settings)
            let rawBookings = bookingController.getFilteredBookings(with: filterPredicate)
            bookings = SortBooking.sortBookings(rawBookings)
        }
        .onChange(of: filterPredicate) { oldValue, newValue in
            isLoading = true
            bookings = []
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let rawBookings = bookingController.getFilteredBookings(with: filterPredicate)
                bookings = SortBooking.sortBookings(rawBookings)
                isLoading = false
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            AdminBookingLogFilterView(activePredicates: $filterPredicate)
        }
    }
}

#Preview {
    @Previewable @State var navPath = NavigationPath()
    AdminBookingLogView(navigationPath: $navPath)
        .environment(Settings())
}
