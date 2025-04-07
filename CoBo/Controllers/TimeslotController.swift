//
//  TimeslotController.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import Foundation
import SwiftData

class TimeslotController {
    var modelContext: ModelContext?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func setupModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllTimeslot() -> [Timeslot] {
        guard let context = modelContext else {
            print("Model Context is Not Available")
            return []
        }
        
        let descriptor = FetchDescriptor<Timeslot>()
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching timeslots: \(error)")
            return []
        }
    }
}
