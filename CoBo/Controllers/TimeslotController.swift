//
//  TimeslotController.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import Foundation
import SwiftData

class TimeslotController {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllTimeslot() -> [Timeslot] {
        let descriptor = FetchDescriptor<Timeslot>()
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching timeslots: \(error)")
            return []
        }
    }
}
