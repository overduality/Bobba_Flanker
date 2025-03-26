//
//  ContentView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 25/03/25.
//

import SwiftUI
import SwiftUI

struct ContentView: View {
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
                        Text("This is Check In Page")
                    }
                    Tab("Booking Log", systemImage: "clock.arrow.circlepath", value: .bookingLog){
                        Text("This is Booking Log Page")
                    }
                }
    }
}

#Preview {
    ContentView()
}

