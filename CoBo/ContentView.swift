//
//  ContentView.swift
//  CoBo
//
//  Created by Evan Lokajaya on 25/03/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    enum Page {
        case bookSpace
        case checkIn
        case bookingLog
    }
    
    @State private var selectedTab = Page.bookSpace
    
    @Query var users: [User]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Book Space", systemImage: "person.fill", value: .bookSpace){
                Text("This is Book Space Page")
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
