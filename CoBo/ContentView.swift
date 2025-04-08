//
//  ContentView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 25/03/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    enum Page {
            case bookSpace
            case checkIn
            case bookingLog
        }

    @State var selectedTab: Page = .bookSpace
    var body: some View {
        TabView(selection: $selectedTab) {
                    Tab("Book Space", systemImage: "person.fill", value: .bookSpace){
                        BookingView()
                    }
                    Tab("Check In", systemImage: "book.closed.fill", value: .checkIn){
                        CheckinView()
                    }
                    Tab("Booking Log", systemImage: "clock.arrow.circlepath", value: .bookingLog){
                        BookingLogView()
                    }
                }
    }
}

#Preview {
    ContentView()
}






