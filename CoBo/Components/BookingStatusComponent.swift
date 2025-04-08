//
//  BookingStatusComponent.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import SwiftUI

struct BookingStatusComponent: View {
    @State var status: BookingStatus
    
    var label: String {
        get {
            return "Awaiting for check-in ⏳"
        }
    }
    
    var color: Color {
        get {
            return Color.yellow.opacity(0.2)
        }
    }
    
    var body: some View {
        Text(label)
            .font(.system(size: 11))
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(color)
    }
}

#Preview {
    VStack {
        BookingStatusComponent(status: .notCheckedIn)
        BookingStatusComponent(status: .notCheckedIn)
        BookingStatusComponent(status: .notCheckedIn)
    }
}
