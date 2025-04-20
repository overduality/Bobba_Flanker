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
    @State private var isLoading: Bool = false
    @State var bookings: [Booking] = []
    
    @State private var showAdminCodeSheet = false
    @State private var adminCodeInput = ""
    @State private var adminCodeErrorMessage: String? = nil
    
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
                        HStack {
                            Text("🧾").font(.system(size: 34)).fontWeight(.bold)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            Spacer()
                            Text(Image(systemName: "person.badge.key"))
                                .font(.system(size: 30)).fontWeight(.bold)
                                .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .topTrailing)
                                .onTapGesture {
                                    showAdminCodeSheet = true
                                }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 75)
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
                .padding(.top, -54)
            }
            .navigationDestination(for: BookingLogDetailContext.self) { context in
                BookingLogDetailsView(navigationPath: $navigationPath, booking: context.booking)
            }
            .navigationDestination(for: AdminSettingsContext.self) { context in
                   AdminSettingView(navigationPath: $navigationPath)
                }
        }
        .onAppear() {
            bookingController.setupModelContext(modelContext)
            bookingController.autoCloseBooking()
            let rawBookings = bookingController.getBookingsByDate(selectedDate)
            bookings = SortBooking.sortBookings(rawBookings)
        }

        .onChange(of: selectedDate) { oldValue, newValue in
            isLoading = true
            bookings = []
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let rawBookings = bookingController.getBookingsByDate(newValue)
                bookings = SortBooking.sortBookings(rawBookings)
                isLoading = false
            }
        }
        .sheet(isPresented: $showAdminCodeSheet) {
            AdminCodeView(
                codeInput: $adminCodeInput,
                errorMessage: $adminCodeErrorMessage,
                onConfirm: validateAdminTotp
            )
        }
    }
    
    func validateAdminTotp() {
        let currentTime = Date().timeIntervalSince1970
        let secretKey = "MYYHC33XJBLVE3RYKU4UG4LZGRZXK42M"
        
        let code = TotpUtil.generateTotp(timestamp: currentTime, secretKey: secretKey, timeStep: 30, digits: 6)
        
        if (code == self.adminCodeInput) {
            adminCodeErrorMessage = nil
            showAdminCodeSheet = false
            
            let adminContext = AdminSettingsContext()
            
            navigationPath.append(adminContext)
        }
        else {
            adminCodeErrorMessage = "Wrong TOTP Code. Please try again"
        }
    }
}

private struct BookingLogSkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkeletonView(RoundedRectangle(cornerRadius: 6))
                .font(.system(size: 14))
                .frame(height: 18)
                .padding(.bottom, 8)
            Divider()
            HStack{
                SkeletonView(RoundedRectangle(cornerRadius: 6))
                    .frame(width:60)
                SkeletonView(RoundedRectangle(cornerRadius: 6))
                    .frame(width:80)

            }
            HStack{
                SkeletonView(RoundedRectangle(cornerRadius: 6))
                    .frame(width:60)
                SkeletonView(RoundedRectangle(cornerRadius: 6))
                    .frame(width:120)

            }
            HStack{
                SkeletonView(RoundedRectangle(cornerRadius: 6))
                    .frame(width:60)
                SkeletonView(RoundedRectangle(cornerRadius: 6))
                    .frame(width:120)

            }
            SkeletonView(RoundedRectangle(cornerRadius: 6))
                .frame(width:60)
            
            HStack{
                SkeletonView(RoundedRectangle(cornerRadius: 12))
                    .frame(width:93, height: 36)
                Spacer()
                SkeletonView(RoundedRectangle(cornerRadius: 0))
                    .frame(width: 160, height: 25, alignment: .trailing)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1)
        .redacted(reason: .placeholder)
    }
}

#Preview {
    BookingLogView()
}
