//
//  BookingLogDetailsView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import SwiftUI
import Foundation

import SwiftUI
import Foundation

struct BookingLogDetailsView: View {
    @Binding var navigationPath: NavigationPath
    var booking: Booking
    
    @State private var users: [User] = []
    @State private var showCancelSheet = false
    @State private var cancelCodeInput = ""
    @State private var cancelErrorMessage: String? = nil
    
    var userController = UserController()
    var bookingController = BookingController()
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ZStack(alignment: .topLeading) {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.pink.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 120)
                    .ignoresSafeArea()
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Spacer()
                        Text("📄 Booking Details")
                            .font(.title2).bold()
                        Spacer()
                    }}.padding(.bottom,-20)
                
                
                
                InfoRow(title: "Name", value: booking.name ?? "N/A")
                Divider()
                
                InfoRow(title: "Date", value: formattedDate(booking.date))
                Divider()
                
                InfoRow(title: "Timeslot", value: booking.timeslot.name)
                Divider()
                
                InfoRow(title: "Collab Space", value: booking.collabSpace.name)
                Divider()
                
                InfoRow(title: "Purpose", value: booking.purpose?.rawValue ?? "N/A")
                Divider()
                
                InfoRow(title: "Status", value: booking.getStatus())
                
                Divider()
                InfoRow(title: "Created At", value: formattedDateTime(booking.createdAt))
                Divider()
                InfoRow(title: "Coordinator", value: booking.coordinator?.name ?? "N/A")
                Divider()
                
                InfoRow(title: "Participants", value: booking.participants.map { $0.name }.joined(separator: ", "))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .ignoresSafeArea()
            .safeAreaPadding()
            
            
        }
        Button(action: {
            showCancelSheet = true
        }) {
            Text("Cancel Booking")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(24)
                .padding(.horizontal, 12)
                .padding(.top, 12)
        }
        
        .safeAreaPadding()
        .navigationTitle("Booking Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            userController.setupModelContext(modelContext)
            users = userController.getAllUser()
            
            // 🧠 Add this:
            bookingController.setupModelContext(modelContext)
        }

        .sheet(isPresented: $showCancelSheet) {
            CancelBookingSheet(
                codeInput: $cancelCodeInput,
                errorMessage: $cancelErrorMessage,
                onConfirm: {
                    validateCancelCode()
                }
            )
        }
        
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func validateCancelCode() {
        if cancelCodeInput == booking.checkInCode {
            if bookingController.cancelBooking(booking) {
                showCancelSheet = false
                cancelErrorMessage = nil
            } else {
                cancelErrorMessage = "Failed to cancel booking. Please try again."
            }
                
        } else {
            cancelErrorMessage = "Invalid check-in code. Please try again."
        }
    }

    
    
    
    struct InfoRow: View {
        var title: String
        var value: String
        
        var body: some View {
            HStack(alignment: .top) {
                Text("\(title):")
                    .bold()
                Spacer()
                Text(value)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    struct CancelBookingSheet: View {
        @Binding var codeInput: String
        @Binding var errorMessage: String?
        var onConfirm: () -> Void
        
        @FocusState private var focusedField: Int?
        
        var body: some View {
            NavigationView {
                VStack(spacing: 24) {
                    Text("Enter the 6-Digit\nCheck-In Code")
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 12) {
                        ForEach(0..<6, id: \.self) { index in
                            CodeBox(index: index, code: $codeInput)
                                .focused($focusedField, equals: index)
                                .onChange(of: codeInput) { _ in
                                    if codeInput.count < 6 {
                                        focusedField = codeInput.count
                                    } else {
                                        focusedField = nil
                                    }
                                }
                        }
                    }
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: onConfirm) {
                        Text("Confirm Cancel")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Cancel Booking")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    focusedField = 0
                }
            }
        }
    }
    
    
    struct CodeBox: View {
        let index: Int
        @Binding var code: String
        
        var body: some View {
            ZStack {
                Rectangle()
                    .frame(width: 45, height: 60)
                    .cornerRadius(8)
                    .foregroundColor(Color.gray.opacity(0.2))
                
                TextField("", text: Binding(
                    get: {
                        if index < code.count {
                            let charIndex = code.index(code.startIndex, offsetBy: index)
                            return String(code[charIndex])
                        } else {
                            return ""
                        }
                    },
                    set: { newValue in
                        guard newValue.count <= 1, newValue.last?.isWholeNumber ?? true else { return }
                        var codeArray = Array(code)
                        if index < codeArray.count {
                            if newValue.isEmpty {
                                codeArray.remove(at: index)
                            } else {
                                codeArray[index] = newValue.last!
                            }
                        } else if index == codeArray.count, !newValue.isEmpty {
                            codeArray.append(newValue.last!)
                        }
                        code = String(codeArray.prefix(6))
                    }
                ))
                .frame(width: 45, height: 60)
                .font(.title)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
            }
        }
    }
}
    #Preview {
        let navigationPath = NavigationPath()
        if let booking = DataManager.getBookingData().first {
            return BookingLogDetailsView(navigationPath: .constant(navigationPath), booking: booking)
        } else {
            return AnyView(Text("No booking data available."))
        }
    }
