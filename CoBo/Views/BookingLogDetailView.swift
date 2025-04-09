//
//  BookingLogDetailsView.swift
//  CoBo
//
//  Created by Rieno on 09/04/25.
//

import SwiftUI
import Foundation

struct BookingLogDetailsView: View {
    @Binding var navigationPath: NavigationPath
    @Bindable var booking: Booking
    @Environment(\.dismiss) var dismiss
    @State private var users: [User] = []
    @State private var showCancelSheet = false
    @State private var cancelCodeInput = ""
    @State private var cancelErrorMessage: String? = nil
    @State private var showCancelButton = false
    @State private var showSuccessAlert = false

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
                    
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Spacer()
                        Text("📄 Booking Details")
                            .font(.title2).bold()
                        Spacer()
                    }                .padding(.horizontal, 16)
                    
                }.alert("Booking Canceled", isPresented: $showSuccessAlert, actions: {}) {
                    Text("Your booking has been successfully canceled.")
                }

                    
                .padding(.bottom, 10)
                Group {
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
                    
                    HStack(alignment: .top) {
                        Text("Participants")
                            .bold()
                            .font(.system(size: 14))
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            if booking.participants.isEmpty {
                                Text("No participants inputted")
                                    .font(.system(size: 13))
                                    .multilineTextAlignment(.trailing)
                            } else {
                                ForEach(booking.participants, id: \.id) { participant in
                                    Text(participant.name)
                                        .font(.system(size: 13))
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                        }
                    }}
         .padding(.horizontal, 16)
                
                
                Spacer()
            }
            
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Booking Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            userController.setupModelContext(modelContext)
            bookingController.setupModelContext(modelContext)
            users = userController.getAllUser()
            showCancelButton = booking.status == .notCheckedIn
            
        
        }
        .sheet(isPresented: $showCancelSheet) {
            CancelBookingSheet(
                codeInput: $cancelCodeInput,
                errorMessage: $cancelErrorMessage,
                onConfirm: validateCancelCode
            )
        }

        if showCancelButton {
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
        guard cancelCodeInput == booking.checkInCode else {
            cancelErrorMessage = "Invalid check-in code. Please try again."
            return
        }

        let success = bookingController.cancelBooking(booking)

            if success {
                cancelErrorMessage = nil
                showCancelSheet = false
                showCancelButton = false
                booking.status = .canceled

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showSuccessAlert = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSuccessAlert = false
                        dismiss()
                    }
                }
    
        } else {
            cancelErrorMessage = "Failed to cancel booking. Please try again."
        }
    }

}

// MARK: - InfoRow
struct InfoRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .bold()
                .font(.system(size: 14))
            Spacer()
            Text(value)
                .font(.system(size: 13))
                .multilineTextAlignment(.trailing)
                .lineLimit(nil)
                
                .fixedSize(horizontal: false, vertical: true)

        }
    }
}

// MARK: - CancelBookingSheet
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
                                focusedField = codeInput.count < 6 ? codeInput.count : nil
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
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(24)
                        .padding(.horizontal, 12)
                        .padding(.top, 12)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Cancel Booking")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { focusedField = 0 }
        }
    }
}

// MARK: - CodeBox
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

#Preview {
    let navigationPath = NavigationPath()
    if let booking = DataManager.getBookingData().first {
        return BookingLogDetailsView(navigationPath: .constant(navigationPath), booking: booking)
    } else {
        return AnyView(Text("No booking data available."))
    }
}
