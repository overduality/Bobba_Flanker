//
//  CoBoApp.swift
//  CoBo
//
//  Created by Evan Lokajaya on 25/03/25.
//

import SwiftUI
import SwiftData

@main
struct CoBoApp: App {
    var body: some Scene {
        WindowGroup {
            SplashscreenView()
        }
        .modelContainer(for: [Booking.self, CollabSpace.self, Timeslot.self, User.self]) { result in
            do {
                let container = try result.get()

                // Populate User data
                try populateData(container: container, fetchDataFunction: DataManager.getUsersData)
               
                // Populate CollabSpace data
                try populateData(container: container,fetchDataFunction: DataManager.getCollabSpacesData)
                
                // Populate Timeslot data
                try populateData(container: container, fetchDataFunction: DataManager.getTimeslotsData)
                
                try populateData(container: container, fetchDataFunction: DataManager.getBookingData)
            } catch {
                print("Failed to pre-seed database.")
            }
        }
    }
    
    private func populateData<T: PersistentModel>(
    container: ModelContainer,
    fetchDataFunction: () -> [T]) throws {
        let descriptor = FetchDescriptor<T>()
        let existingCount = try container.mainContext.fetchCount(descriptor)
        
        if existingCount == 0 {
            for item in fetchDataFunction() {
                container.mainContext.insert(item)
            }
        }
        
        try container.mainContext.save()
    }
}
