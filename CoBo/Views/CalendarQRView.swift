//
//  CalendarQRView.swift
//  Project 1 Apple
//
//  Created by Rieno on 25/03/25.
//
import SwiftUI
import CoreImage.CIFilterBuiltins

struct CalendarQRView: View {
    @Environment(\.dismiss) var dismiss
    let booking: Booking
    var qrCodeText: String {
        generateQRCodeFromBooking(booking)
    }
    
    var body: some View {
        VStack {
            Text("Scan this QR code to automatically create event in your iCal for a timely reminder for you and all participants.")
                .font(.system(size: 12))
                if let qrImage = generateQRCode(from: qrCodeText) {
                    qrImage
                        .resizable()
                        .interpolation(.none)
                      .frame(width: 200, height: 200)
                        .background(Color.gray.opacity(0.2))
                } else {
                    Text("Failed to generate QR code")
                        .foregroundColor(.red)
                }
                            }
        }
    }
    

